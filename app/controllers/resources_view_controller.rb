require 'trend'

class ResourcesViewController < ApplicationController
  def index
    @timefactor = params[:timefactor].to_i
    @timefactor = 1 unless not @timefactor.nil? and @timefactor > 1 and @timefactor <= 64 
 
    influxdata = RivalResourceMetrics.select("MEAN(lowest_market_price)").group(:rivals_resource_id).time("#{@timefactor * 15}m").fill(:null).order(time: :desc).limit(50)
   
    @graphdata = Hash.new
    influxdata.each do |record|
      @graphdata[record["rivals_resource_id"]] = Array.new unless not @graphdata[record["rivals_resource_id"]].nil?
      @graphdata[record["rivals_resource_id"]] << [ record["time"], record["mean"] ]
    end
 
    render 'resources/index' 
  end

  def predict
    @predicting = {}
    @baseseries = Array.new

    influxdata = RivalResourceMetrics.select("MEAN(lowest_market_price)").time('15m').fill(:none).where("rivals_resource_id = '3'").order(time: :desc).limit(96)
    influxdata.each do |record|
      @baseseries << [ record["time"], record["mean"] ]
      @predicting[record["time"]] = record["mean"]
    end
   
    result = Trend.forecast(@predicting, count: 24)

    @predicted = Array.new
    result.map do |key, val|
      @predicted << [ key, val ]
    end

    render 'resources/predict'
  end
end
