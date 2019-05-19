class RemoveInstrumentPrices < ActiveRecord::Migration[5.2]
  def change
    drop_table "instrument_prices" do |t|
      t.bigint "instrument_id", null: false
      t.date "date", null: false
      t.integer "price_cents", default: 0, null: false
      t.string "price_currency", default: "USD", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["instrument_id", "date"], name: "index_instrument_prices_on_instrument_id_and_date", unique: true
    end
  end
end
