class RivalUser < ApplicationRecord
  self.primary_key = "rivals_user_id"
  
  attribute :rivals_user_id, :big_integer
  attribute :name, :string
end
