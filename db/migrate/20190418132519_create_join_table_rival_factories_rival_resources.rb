class CreateJoinTableRivalFactoriesRivalResources < ActiveRecord::Migration[5.2]
  def change
    create_join_table :rival_factories, :rival_resources do |t|
      # t.index [:rival_factory_id, :rival_resource_id]
      # t.index [:rival_resource_id, :rival_factory_id]
    end
  end
end
