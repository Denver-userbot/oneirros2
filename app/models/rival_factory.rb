class RivalFactory < ApplicationRecord
  self.primary_key = "rivals_factory_id"
  
  attribute :rivals_factory_id, :big_integer
  attribute :name, :string

  belongs_to :company, class_name: "OneirrosCompany"
  belongs_to    :type, class_name: "RivalResource"
end
