class RivalRegion < ApplicationRecord
  self.primary_key = "rivals_id"

  attribute :name_ru, :string
  attribute :name_en, :string
  attribute :rivals_id, :big_integer

  has_metrics :metrics, foreign_key: :rivals_id
  attr_accessor :metrics_cached
end
