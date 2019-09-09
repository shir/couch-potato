# frozen_string_literal: true

class CreateDateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :date_records do |t|
      t.date :date, null: false
      t.boolean :rebalance, null: false, default: false

      t.timestamps
    end

    add_index :date_records, :date, unique: true
  end
end
