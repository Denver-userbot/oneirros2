class CreateRivalUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rival_users do |t|
      t.bigint :rivalid
      t.string :name

      t.timestamps
    end
  end
end
