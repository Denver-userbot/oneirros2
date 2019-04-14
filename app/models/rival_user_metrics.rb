require 'bundler/setup'
require 'influxer'

class RivalUserMetrics < Influxer::Metrics
  default_scope -> { limit(1).order(time: :desc) }
  scope :by_user, -> (id) { where(rivals_id: id) }

  tags :rivals_id
  attributes :strength :education :endurance :level

  validates :rivals_id, presence: true
end 
