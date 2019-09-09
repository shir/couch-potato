# frozen_string_literal: ture

class AddDateRecordToInstrumentAmounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :instrument_amounts, :date_record, foreign_key: true
    reversible do |dir|
      dir.up do
        InstrumentAmount.reset_column_information
        InstrumentAmount.find_each do |ia|
          ia.update_columns(date_record_id: DateRecord.find_or_create_by!(date: ia.date).id)
        end
        change_column_null :instrument_amounts, :date_record_id, false
        remove_column :instrument_amounts, :date, :date
      end
      dir.down do
        add_column :instrument_amounts, :date, :date
        InstrumentAmount.find_each do |ia|
          ia.update_columns(date: ia.date_record&.date)
        end
        change_column_null :instrument_amounts, :date_record_id, false
      end
    end
  end
end
