class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :date_record, foreign_key: true, index: false
      t.references :instrument, foreign_key: true, index: false
      t.integer :count, null: false
      t.integer :price_cents, null: false, default: 0

      t.timestamps

      t.index %i[date_record_id instrument_id], unique: true
    end
  end
end
