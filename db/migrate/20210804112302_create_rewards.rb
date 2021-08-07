class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :reward_name
      t.string :start_date
      t.string :end_date
      t.string :condition
      t.timestamps
    end
  end
end
