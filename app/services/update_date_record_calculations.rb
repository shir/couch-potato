# frozen_string_literal: true

class UpdateDateRecordCalculations < BaseService
  attr_accessor :date_record

  def initialize(date_record)
    @date_record = date_record
  end

  def perform
    CollectPurchases.perform if date_record.rebalance?

    date_record.total_amounts['RUB'] =
      CalculateDateRecordTotal.perform(date_record, 'RUB').to_f.round(2)
    date_record.profits['RUB'] =
      CalculateDateRecordProfit.perform(date_record, 'RUB').to_f.round(2)
    date_record.save!
  end
end
