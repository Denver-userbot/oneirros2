class Initial < ActiveRecord::Migration[5.2]
  def change
    create_table :rival_regions do |t|
      t.bigint :rivals_id
      t.string :name_ru
      t.string :name_en
      t.timestamps
    end
  end
end
