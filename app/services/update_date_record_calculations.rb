# frozen_string_literal: true

class UpdateDateRecordCalculations < BaseService
  attr_accessor :date_record

  def initialize(date_record)
    @date_record = date_record
  end

  def perform
    date_record.recalculate_total_amounts
    date_record.recalculate_profits
    date_record.save!
  end
end
