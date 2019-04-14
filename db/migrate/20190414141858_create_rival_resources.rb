class CreateRivalResources < ActiveRecord::Migration[5.2]
  def change
    create_table :rival_resources do |t|
      t.bigint :rivals_resource_id 
      t.string :name
    end
  end
end
