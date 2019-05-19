class InstrumentPricesChart < BaseQuery
  BASE = 100.freeze

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    Instrument.all.map do |instrument|
      {
        name: instrument.ticker,
        data: data(instrument)
      }
    end
  end

  private

  def data(instrument)
    amounts = instrument.amounts.order(date: :asc)
    amounts = amounts.where('"instrument_amounts"."date" >= ?', start_date) if start_date.present?
    first_amount = amounts.first
    base = Money.from_amount(BASE, first_amount.price.currency).to_f
    amounts.each_with_object({}) do |amount, d|
      d[amount.date] = (amount.price.to_f * base / first_amount.price.to_f).round(2)
    end
  end
end
