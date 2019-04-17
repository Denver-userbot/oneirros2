class RegionsViewController < ApplicationController 
  include RegionCostHelper

  def index
    @results_by_id = Hash.new

    # Query ActiveRecord for static data
    regions = RivalRegion.all
    regions.each do |region|
      region_id = region[:rivals_id]

      @results_by_id[region_id] = Hash.new
      @results_by_id[region_id][:id] = region_id
      @results_by_id[region_id][:region] = region
    end

    # Query Influx in Bulk and merge
    RivalRegionMetrics.all.group(:rivals_id).order(time: :desc).each do |metric|
      region_id = metric["rivals_id"].to_i

      @results_by_id[region_id][:metrics] = metric
    end
  
    render 'regions/index'
  end

  def show
    @region = RivalRegion.find(params[:id])
    @metrics = RivalRegionMetrics.by_region(params[:id]).to_a.first
    @loot_res = compute_all_loot(@metrics) 
    @build_res = compute_all_cost(@metrics)    

    render 'regions/show'
  end

  def simulator
    @influx_prices = get_influx_prices
    render 'regions/simulator'
  end

  def simulator_submit
    @params = params

    @simulated_buildings = Array.new
    REGION_COST_BUILDING_LIST.each do |building|
      start = get_level_if_defined(@params["start_#{building}"])
      target = get_level_if_defined(@params["target_#{building}"], @params["start_#{building}"])
      @simulated_buildings << compute_cost(building, target, start) unless target == 0 or start >= target 
    end

    @simulated_cost = sum_costs(@simulated_buildings)
    @influx_prices = get_influx_prices
  
    # init prices
    @res_prices = Hash.new
    # FIXME: Determine state_cash and state_gold prices dynamically
    @res_prices["state_cash"] = 0.7
    @res_prices["state_gold"] = 0.35
    # Glue with prices from influx
    @res_prices["oil"] = @influx_prices["3"].to_f
    @res_prices["ore"] = @influx_prices["4"].to_f
    @res_prices["dia"] = @influx_prices["15"].to_f
    @res_prices["ura"] = @influx_prices["11"].to_f
 
    @price = 0.0
    RegionCostHelper::REGION_COST_RESOURCES.each do |res|
       @res_prices[res] = @params["price_#{res}"].to_f unless @params["price_#{res}"].to_f == 0
       @price += @simulated_cost[res] * @res_prices[res]
    end

    render 'regions/simulator'
  end

  def simulator_byregion
    @region = RivalRegion.find(params[:id]) 
    @metrics = RivalRegionMetrics.by_region(params[:id]).to_a.first

    render 'regions/simulator'
  end

  def get_level_if_defined(strinput, default = 0) 
    return default.to_i unless not strinput.nil?
    return strinput.to_i unless strinput.empty? or strinput.to_i < 0
    return default.to_i
  end

  def get_influx_prices() 
    # Glue together prices and resources
    influx_prices = Hash.new
    ["3", "4", "11", "15"].each do |resid|
      influx_query = RivalResourceMetrics.select("MEAN(lowest_market_price)").time('4h').fill(:previous).order(time: :desc).where("rivals_resource_id = '#{resid}'").limit(1)
      influx_query.each do |record|
        influx_prices[influx_res_to_attribute(resid)] = record["mean"].to_f
      end
    end
    return influx_prices 
  end

  def influx_res_to_attribute(influxid) 
    return case influxid.to_i
      when 3 then "oil"
      when 4 then "ore"
      when 15 then "dia"
      when 11 then "ura"
    end
  end
end
