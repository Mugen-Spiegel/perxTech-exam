class CreatePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.float :points
      t.float :total_points
      t.string :multiplier
      t.references :customer, null: false, foreign_key: true
      t.references :customer_transaction, null: true, foreign_key: true
      t.datetime :transaction_date
      t.timestamps
    end
  end
end
