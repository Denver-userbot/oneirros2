require 'pp'

class RegionsController < ApplicationController
  def index
    merger = Hash.new

    # Query all regions in bulk
    @regions = RivalRegion.all
    @regions.each do |region|
      merger[region[:rivals_id]] = region
    end

    # Also query last region metrics in bulk
    RivalRegionMetrics.all.group(:rivals_id).order(time: :desc).each do |metric|
      merger[metric["rivals_id"].to_i].metrics_cached = metric
    end 
    
    render json: @regions, each_serializer: RivalRegionCachedSerializer
  end

  def show
    entry = RivalRegion.find(params[:id])
    render json: entry, serializer: RivalRegionSerializer
  end
end
