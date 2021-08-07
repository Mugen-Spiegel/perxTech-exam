# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_04_112314) do

  create_table "clients", force: :cascade do |t|
    t.string "company_name"
    t.string "company_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customer_rewards", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "reward_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_customer_rewards_on_customer_id"
    t.index ["reward_id"], name: "index_customer_rewards_on_reward_id"
  end

  create_table "customer_transactions", force: :cascade do |t|
    t.float "amount"
    t.string "currency"
    t.datetime "transaction_date"
    t.string "country"
    t.integer "client_id", null: false
    t.integer "customer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_customer_transactions_on_client_id"
    t.index ["customer_id"], name: "index_customer_transactions_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.datetime "birthdate"
    t.string "origin_country"
    t.integer "client_id", null: false
    t.string "points"
    t.string "tier"
    t.string "types"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_customers_on_client_id"
  end

  create_table "points", force: :cascade do |t|
    t.float "points"
    t.float "total_points"
    t.string "multiplier"
    t.integer "customer_id", null: false
    t.integer "customer_transaction_id"
    t.datetime "transaction_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_points_on_customer_id"
    t.index ["customer_transaction_id"], name: "index_points_on_customer_transaction_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "reward_name"
    t.string "start_date"
    t.string "end_date"
    t.string "condition"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "customer_rewards", "customers"
  add_foreign_key "customer_rewards", "rewards"
  add_foreign_key "customer_transactions", "clients"
  add_foreign_key "customer_transactions", "customers"
  add_foreign_key "customers", "clients"
  add_foreign_key "points", "customer_transactions"
  add_foreign_key "points", "customers"
end
