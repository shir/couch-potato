# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_06_182344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "currency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "balances", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "account_id", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_balances_on_account_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.date "date", null: false
    t.jsonb "rates", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_exchange_rates_on_date", unique: true
  end

  create_table "instrument_amounts", force: :cascade do |t|
    t.bigint "instrument_id", null: false
    t.date "date", null: false
    t.integer "count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.index ["instrument_id", "date"], name: "index_instrument_amounts_on_instrument_id_and_date", unique: true
  end

  create_table "instruments", force: :cascade do |t|
    t.string "ticker", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency", null: false
    t.boolean "hidden", default: false, null: false
  end

  add_foreign_key "balances", "accounts"
  add_foreign_key "instrument_amounts", "instruments"
end
