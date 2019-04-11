class CreateRivalRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :rival_regions do |t|
      t.bigint :rivalid
      t.string :name
      t.string :runame

      t.timestamps
    end
  end
end
