class AddTotalAmountsToDateRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :date_records, :total_amounts, :jsonb, null: false, default: {}
  end
end
