class RivalFactory < ActiveRecord::Migration[5.2]
  def change
    create_table :rival_factories, :id => false, :primary_key => :rivals_factory_id do |t|
      t.bigint :rivals_factory_id
      t.string :name
      t.timestamps
    end
  end
end
