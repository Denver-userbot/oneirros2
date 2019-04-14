class RivalResource < ApplicationRecord
  self.primary_key = "rivals_resource_id"

  attribute :rivals_resource_id, :big_integer
  attribute :name, :string
end
