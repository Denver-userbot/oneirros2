require 'pp'

class RegionsController < ApplicationController

  api :GET, '/regions', 'List registered regions'
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

  api :GET, '/regions/:id', 'Get information on a specific Region'
  param :id, String, :desc => "Region ID in RivalRegions", :required => true
  def show
    entry = RivalRegion.find(params[:id])
    render json: entry, serializer: RivalRegionSerializer
  end
end
