class RivalRegionCachedSerializer < RivalRegionSlimSerializer
  has_one :metrics, each_serializer: RivalRegionMetricsSerializer do |serializer|
    serializer.object.metrics_cached
  end
end
