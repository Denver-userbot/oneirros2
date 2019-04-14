class RivalResourceMetrics < Influxer::Metrics
  set_series :resource

  default_scope -> { limit(1).order(time: :desc) }
  scope :by_resource, -> (id) { where(rivals_resource_id: id) }
  
  tags :rivals_resource_id
  attributes :lowest_market_price

  validates :rivals_resource_id, presence: true
end
