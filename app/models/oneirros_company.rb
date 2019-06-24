class OneirrosCompany < ApplicationRecord
  attribute :name, :string
  has_many :factories, class_name: "RivalFactory"
end
