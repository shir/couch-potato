# frozen_string_literal: true

class TotalAmountChart < BaseQuery
  DEFAULT_CURRENCY = 'RUB'

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    @result ||= {}.tap do |data|
      collect_amounts_data(data)
      collect_balances_data(data)
    end
  end

  def rebalances
    # if `@rebalances` are blank run `result` to build rebalances
    result unless @rebalances

    @rebalances
  end

  private

  def collect_amounts_data(data)
    amounts.each do |amount|
      data[amount.date_record.date] ||= 0.0
      data[amount.date_record.date] += (price(amount) * amount.count).to_f

      add_rebalance(amount.date_record) if amount.date_record.rebalance?
    end
  end

  def collect_balances_data(data)
    balances.each do |balance|
      data[balance.date_record.date] ||= 0.0
      data[balance.date_record.date] += balance_amount(balance).to_f

      add_rebalance(balance.date_record) if balance.date_record.rebalance?
    end
  end

  def add_rebalance(date_record)
    @rebalances ||= []
    @rebalances << date_record.date unless @rebalances.include?(date_record.date)
  end

  def amounts
    @amounts ||= InstrumentAmount
      .joins(:date_record)
      .preload(:instrument, date_record: :exchange_rate)
      .order(Arel.sql('"date_records"."date" ASC'))
  end

  def balances
    @balances ||= Balance
      .joins(:date_record)
      .preload(:account, date_record: :exchange_rate)
      .order(Arel.sql('"date_records"."date" ASC'))
  end

  def price(amount)
    if amount.currency == DEFAULT_CURRENCY
      amount.price
    else
      rate = amount.date_record.exchange_rate
      Money.new(amount.price.cents * rate.rate(amount.currency).to_f, DEFAULT_CURRENCY)
    end
  end

  def balance_amount(balance)
    if balance.currency == DEFAULT_CURRENCY
      balance.amount
    else
      rate = balance.date_record.exchange_rate
      Money.new(balance.amount.cents * rate.rate(balance.currency).to_f, DEFAULT_CURRENCY)
    end
  end
end
