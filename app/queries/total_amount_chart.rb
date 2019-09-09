# frozen_string_literal: true

class TotalAmountChart < BaseQuery
  DEFAULT_CURRENCY = 'RUB'

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    date_records.each_with_object({}) do |date_record, data|
      data[date_record.date] = date_data(date_record)
    end
  end

  private

  def date_records
    @date_records ||= DateRecord.order(date: :asc)
  end

  def date_data(date_record)
    rate = date_record.exchange_rate
    date_record.instrument_amounts
      .inject(Money.from_amount(0, DEFAULT_CURRENCY)) do |sum, amount|
      price =
        if amount.currency == DEFAULT_CURRENCY
          amount.price
        else
          Money.new(amount.price.cents * rate.rates[amount.currency].to_f, DEFAULT_CURRENCY)
        end
      sum + (price * amount.count)
    end.to_f
  end
end
