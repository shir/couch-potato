# frozen_string_literal: true

class InstrumentPricesChart < BaseQuery
  BASE = 100

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    Instrument.visible.map do |instrument|
      {
        name: instrument.ticker,
        data: data(instrument),
      }
    end
  end

  private

  def data(instrument)
    amounts = amounts(instrument)
    first_amount = amounts.to_a.last
    base = Money.from_amount(BASE, instrument.currency).to_f
    amounts.to_a.each_with_object({}) do |amount, d|
      next if amount.count.zero?

      d[amount.date_record.date] = (amount.absolute_price.to_f * base / first_amount.absolute_price.to_f).round(2)
    end
  end

  def amounts(instrument)
    amounts = instrument.amounts
      .select(%(DISTINCT ON (month) date_trunc('month', "date_records"."date") as month, "instrument_amounts".*))
      .joins(:date_record)
      .preload(:date_record)
      .order(Arel.sql('month DESC, "date_records"."date" DESC'))
    amounts = amounts.where('"date_records"."date" >= ?', start_date) if start_date.present?
    amounts
  end
end
