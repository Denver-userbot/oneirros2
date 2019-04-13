class RivalRegionSerializer < ActiveModel::Serializer 
  attributes :rivals_id, :name_en, :updated_at

  has_one :metrics, each_serializer: RivalRegionMetricsSerializer do |serializer|
    RivalRegionMetrics.by_region(serializer.attributes[:rivals_id]).to_a.first
  end
end
