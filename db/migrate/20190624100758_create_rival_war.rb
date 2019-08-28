class CreateRivalWar < ActiveRecord::Migration[5.2]
  def change
    create_table :rival_wars do |t|
      t.bigint :rivals_id
      t.bigint :attacking_region
      t.bigint :defending_region
      t.bigint :wallsnapshot
      t.integer :wartype
    end
  end
end
