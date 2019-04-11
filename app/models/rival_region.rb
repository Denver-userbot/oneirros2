class RivalRegion < ApplicationRecord
  self.primary_key = "rival_id"

  attribute :name_ru, :string
  attribute :name_en, :string
  attribute :rival_id, :bigint

  has_metrics :metrics
end
