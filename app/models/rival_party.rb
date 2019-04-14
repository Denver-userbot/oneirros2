class RivalParty < ApplicationRecord
  self.primary_key = "rivals_id"

  attribute :name, :string
  attribute :rivals_id, :big_integer
  attribute :picture, :string

  has_one :region, class_name: "RivalRegion"
  has_many :user, class_name: "RivalUser" 
end
