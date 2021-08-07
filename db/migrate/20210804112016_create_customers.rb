class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :last_name
      t.string :first_name
      t.datetime :birthdate
      t.string :origin_country
      t.references :client, null: false, foreign_key: true
      t.string :points
      t.string :tier
      t.string :types
      t.timestamps
    end
    
  end
end
