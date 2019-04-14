require 'pp'

class RegionsViewController < ApplicationController 
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
end
