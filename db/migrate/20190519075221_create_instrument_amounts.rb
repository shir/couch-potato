class CreateInstrumentAmounts < ActiveRecord::Migration[5.2]
  def change
    create_table :instrument_amounts do |t|
      t.references :instrument, index: false, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :amount, null: false

      t.timestamps
      t.index %i[instrument_id date], unique: true
    end
  end
end
