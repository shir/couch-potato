# frozen_string_literal: true

class AddDateRecordToBalances < ActiveRecord::Migration[5.2]
  def change
    add_reference :balances, :date_record, foreign_key: true
    reversible do |dir|
      dir.up do
        Balance.reset_column_information
        Balance.find_each do |balance|
          balance.update_columns(date_record_id: DateRecord.find_or_create_by!(date: balance.date).id)
        end
        change_column_null :balances, :date_record_id, false
        remove_column :balances, :date, :date
      end
      dir.down do
        add_column :balances, :date, :date
        Balance.find_each do |balance|
          balance.update_columns(date: balance.date_record&.date)
        end
        change_column_null :balances, :date_record_id, false
      end
    end
  end
end
