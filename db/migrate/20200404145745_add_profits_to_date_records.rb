class AddProfitsToDateRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :date_records, :profits, :jsonb, null: false, default: {}
  end
end
