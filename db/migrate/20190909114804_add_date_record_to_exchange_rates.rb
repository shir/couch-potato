# frozen_string_literal: true

class AddDateRecordToExchangeRates < ActiveRecord::Migration[5.2]
  def change
    add_reference :exchange_rates, :date_record, foreign_key: true
    reversible do |dir|
      dir.up do
        ExchangeRate.reset_column_information
        ExchangeRate.find_each do |er|
          er.update_columns(date_record_id: DateRecord.find_or_create_by!(date: er.date).id)
        end
        change_column_null :exchange_rates, :date_record_id, false
        remove_column :exchange_rates, :date, :date
      end
      dir.down do
        add_column :exchange_rates, :date, :date
        ExchangeRate.find_each do |er|
          er.update_columns(date: er.date_record&.date)
        end
        change_column_null :exchange_rates, :date_record_id, false
      end
    end
  end
end
