require 'bundler/setup'
require 'influxer'

class RivalRegionMetrics < Influxer::Metrics
  set_series :region
  default_scope -> { time(:day).last(1) }
  tags :rivalid
  attributes :hospital, :militarybase, :school
  validates :rivalid, presence: true
end 
