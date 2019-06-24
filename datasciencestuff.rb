require 'pp'
require 'csv'

SERIES_TYPES = ["diamond", "airport", "port", "missile", "power_plant"]
SERIES_VARIABLES_TYPES = ["airport", "port", "missile", "power_plant"]

# Get series from Influx
influxdata_resource = RivalResourceMetrics.select("MEAN(lowest_market_price) AS diamond").where("rivals_resource_id = '15'").time('30m').fill(:none).order(time: :desc).limit(0)
influxdata_building = RivalRegionMetrics.select("MEAN(airport) AS airport, MEAN(port) AS port, MEAN(missile) AS missile, MEAN(power_plant) AS power_plant").time('30m').fill(:none).order(time: :desc).limit(0)

# Get overall values for standardization
influxdata_resstats = RivalResourceMetrics.select("MIN(lowest_market_price), MAX(lowest_market_price), STDDEV(lowest_market_price), MEAN(lowest_market_price)").where("rivals_resource_id = '15'")

coeffs = Hash.new
coeffs[:stddev] = Hash.new
coeffs[:mean] = Hash.new
coeffs[:min] = Hash.new
coeffs[:max] = Hash.new


coeffs[:stddev]["diamond"] = influxdata_resstats.to_a[0]["stddev"]
coeffs[:mean]["diamond"] = influxdata_resstats.to_a[0]["mean"]
coeffs[:min]["diamond"] = influxdata_resstats.to_a[0]["min"]
coeffs[:max]["diamond"] = influxdata_resstats.to_a[0]["max"]

SERIES_VARIABLES_TYPES.each do |ones|
  result = RivalRegionMetrics.select("MIN(#{ones}), MAX(#{ones}), MEAN(#{ones}) AS mean, STDDEV(#{ones}) AS stddev")
  coeffs[:stddev][ones] = result.to_a[0]["stddev"]
  coeffs[:mean][ones] = result.to_a[0]["mean"]
  coeffs[:min][ones] = result.to_a[0]["min"]
  coeffs[:max][ones] = result.to_a[0]["max"]
end


# Tranform them into a array of values
series = Hash.new

def influx2array(influxdata, param) 
  array = Array.new
  influxdata.each do |record|
    array << record[param]
  end
  return array
end

series["diamond"] = influx2array(influxdata_resource, "diamond")
series["airport"] = influx2array(influxdata_building, "airport")
series["port"] = influx2array(influxdata_building, "port")
series["missile"] = influx2array(influxdata_building, "missile")
series["power_plant"] = influx2array(influxdata_building, "power_plant")

# Find number of common values, we'll discard the rest from further processing
values_amount = Array.new
SERIES_TYPES.each do |ones|
  values_amount << series[ones].length
end
considered_values = values_amount.min

# Normalize variables, discard extras and output to CSV
CSV.open('normseries.csv', 'w') do |csv|
  for i in 0..(considered_values-1)
    record = Array.new
    SERIES_TYPES.each do |ones|
      record << ( series[ones][i].to_f - coeffs[:min][ones] ) / ( coeffs[:max][ones] - coeffs[:min][ones] )
    #      record << ( series[ones][i].to_f - means[ones].to_f  ) / ( stddevs[ones].to_f )
    end
    csv << record
  end
end

puts "Done"
pp coeffs
