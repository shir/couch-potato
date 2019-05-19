class CreateExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_rates do |t|
      t.date :date, null: false
      t.jsonb :rates, null: false, default: {}

      t.timestamps
      t.index :date, unique: true
    end
  end
end
