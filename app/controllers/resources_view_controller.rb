require 'pp'

class ResourcesViewController < ApplicationController
  def index
    influxdata = RivalResourceMetrics.select("MEAN(lowest_market_price)").group(:rivals_resource_id).time("5m").fill(:none).order(time: :desc).limit(20)
   
    @graphdata = Hash.new
    influxdata.each do |record|
      @graphdata[record["rivals_resource_id"]] = Array.new unless not @graphdata[record["rivals_resource_id"]].nil?
      @graphdata[record["rivals_resource_id"]] << [ record["time"], record["mean"] ]
    end
 
    render 'resources/index'
  end
end
