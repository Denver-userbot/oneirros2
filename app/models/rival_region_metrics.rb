require 'bundler/setup'
require 'influxer'

class RivalRegionMetrics < Influxer::Metrics
  set_series :region
  default_scope -> { time(:day).last(1) }
  tags :rivals_id
  attributes :hospital, :military_base, :school
  validates :rivals_id, presence: true
end 
