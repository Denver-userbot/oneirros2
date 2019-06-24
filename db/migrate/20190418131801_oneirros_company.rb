class OneirrosCompany < ActiveRecord::Migration[5.2]
  def change
    create_table :oneirros_companies do |t|
      t.string :name
    end
  end
end
