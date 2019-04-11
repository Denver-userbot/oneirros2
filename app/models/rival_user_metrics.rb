require 'bundler/setup'
require 'influxer'

class RivalUserMetrics < Influxer::Metrics
  default_scope -> { time(:day).last() }
  tags :rivalid
  attributes :strength :education :endurance :level :experience :damage
end 
