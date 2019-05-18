class CreateInstrumentPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :instrument_prices do |t|
      t.references :instrument, foreign_key: true, index: false, null: false
      t.date :date, null: false
      t.monetize :price, null: false

      t.timestamps
    end

    add_index :instrument_prices, %i[instrument_id date], unique: true
  end
end
