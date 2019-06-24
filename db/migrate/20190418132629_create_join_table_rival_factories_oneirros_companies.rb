class CreateJoinTableRivalFactoriesOneirrosCompanies < ActiveRecord::Migration[5.2]
  def change
    create_join_table :rival_factories, :oneirros_companies do |t|
      # t.index [:rival_factory_id, :oneirros_company_id]
      # t.index [:oneirros_company_id, :rival_factory_id]
    end
  end
end
