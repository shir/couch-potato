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
    first_amount = amounts.to_a.first
    base = Money.from_amount(BASE, instrument.currency).to_f
    amounts.to_a.each_with_object({}) do |amount, d|
      d[amount.date] = (amount.absolute_price.to_f * base / first_amount.absolute_price.to_f).round(2)
    end
  end
end
