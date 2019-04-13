class RivalRegionSerializer < ActiveModel::Serializer 
  def full_serialize?
    return true
  end

  attributes :rivals_id, :name_en, :updated_at

  has_one :metrics, each_serializer: RivalRegionMetricsSerializer, if: :full_serialize? do |serializer|
    RivalRegionMetrics.by_region(serializer.attributes[:rivals_id]).to_a.first
  end
end
