# frozen_string_literal: true

class TotalAmountChart < BaseQuery
  DEFAULT_CURRENCY = 'RUB'

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    {}.tap do |data|
      collect_amounts_data(data)
      collect_balances_data(data)
    end
  end

  private

  def collect_amounts_data(data)
    amounts.each do |amount|
      data[amount.date_record.date] ||= 0.0
      data[amount.date_record.date] += (price(amount) * amount.count).to_f
    end
  end

  def collect_balances_data(data)
    balances.each do |balance|
      data[balance.date_record.date] ||= 0.0
      data[balance.date_record.date] += balance_amount(balance).to_f
    end
  end

  def amounts
    InstrumentAmount
      .joins(:date_record)
      .preload(:instrument, date_record: :exchange_rate)
      .order(Arel.sql('"date_records"."date" ASC'))
  end

  def balances
    Balance
      .joins(:date_record)
      .preload(:account, date_record: :exchange_rate)
      .order(Arel.sql('"date_records"."date" ASC'))
  end

  def price(amount)
    if amount.currency == DEFAULT_CURRENCY
      amount.price
    else
      rate = amount.date_record.exchange_rate
      Money.new(amount.price.cents * rate.rates[amount.currency].to_f, DEFAULT_CURRENCY)
    end
  end

  def balance_amount(balance)
    if balance.currency == DEFAULT_CURRENCY
      balance.amount
    else
      rate = balance.date_record.exchange_rate
      Money.new(balance.amount.cents * rate.rates[balance.currency].to_f, DEFAULT_CURRENCY)
    end
  end
end
