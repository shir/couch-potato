class TotalAmountChart < BaseQuery
  DEFAULT_CURRENCY = 'RUB'

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    dates.each_with_object({}) do |date, data|
      data[date] = date_data(date)
    end
  end

  private

  def dates
    @dates ||= InstrumentAmount.order(date: :asc).distinct.pluck(:date)
  end

  def date_data(date)
    rate = rates[date]
    InstrumentAmount.includes(:instrument).where(date: date)
      .inject(Money.from_amount(0, DEFAULT_CURRENCY)) do |sum, amount|
      price =
        if amount.currency == DEFAULT_CURRENCY
          amount.price
        else
          Money.new(amount.price.cents * rate.rates[amount.currency], DEFAULT_CURRENCY)
        end
      Rails.logger.debug "price: #{price.inspect}"
      sum + (price * amount.count)
    end.to_f
  end

  def rates
    @rates ||= ExchangeRate.where(date: dates).index_by(&:date)
  end
end
