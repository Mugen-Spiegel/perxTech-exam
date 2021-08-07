class CreateCustomerTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_transactions do |t|
      t.float :amount
      t.string :currency
      t.datetime :transaction_date
      t.string :country
      t.references :client, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
