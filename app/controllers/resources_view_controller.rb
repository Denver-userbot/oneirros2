require 'pp'

class ResourcesViewController < ApplicationController
  def index
    @timefactor = params[:timefactor].to_i
    @timefactor = 1 unless not @timefactor.nil? and @timefactor > 1 and @timefactor <= 64 
 
    influxdata = RivalResourceMetrics.select("MEAN(lowest_market_price)").group(:rivals_resource_id).time("#{@timefactor * 15}m").fill(:null).order(time: :desc).limit(96)
   
    @graphdata = Hash.new
    influxdata.each do |record|
      @graphdata[record["rivals_resource_id"]] = Array.new unless not @graphdata[record["rivals_resource_id"]].nil?
      @graphdata[record["rivals_resource_id"]] << [ record["time"], record["mean"] ]
    end
 
    render 'resources/index' 
  end
 
  def denormalize(coefs, value)
    return value.to_f * (coefs[:max] - coefs[:min]) + coefs[:min]
  end

  def destandardize(coefs, value)
    return value.to_f * coefs[:stddev] + coefs[:mean]
  end

  def predict
    @coefs = Hash.new
    @predicted = Hash.new
    
    rows = CSV.read('norm_coeffs.csv', :headers => true) 
    rows.each do |row|
      @coefs[row["variable"]] = Hash.new
      @coefs[row["variable"]][:min] = row["min"].to_f
      @coefs[row["variable"]][:max] = row["max"].to_f
      @coefs[row["variable"]][:mean] = row["mean"].to_f
      @coefs[row["variable"]][:stddev] = row["stddev"].to_f
    end
 
    ["oil", "ore", "uranium", "diamonds"].each do |res|
       @predicted[res] = Array.new      
    end

    rows = CSV.read('results.csv', :headers => true) 
    rows.each do |row|
      ["oil", "ore", "uranium", "diamonds"].each do |res|
        @predicted[res] << [ DateTime.strptime(row["time"], '%s').to_s, denormalize(@coefs[res], row[res]) ]
      end
    end

    @baseseries = Hash.new

    [3, 4, 11, 15].each do |res|
      @baseseries[res] = Array.new
      influxdata = RivalResourceMetrics.select("MEAN(lowest_market_price)").time('30m').fill(:none).where("rivals_resource_id = '#{res}'").order(time: :desc).limit(64)
      influxdata.each do |record|
        @baseseries[res] << [ record["time"], record["mean"] ]
      end
    end

    render 'resources/predict'
  end
end
