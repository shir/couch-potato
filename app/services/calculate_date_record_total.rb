# frozen_string_literal: true

class CalculateDateRecordTotal < BaseService
  attr_reader :date_record, :currency

  def initialize(date_record, currency)
    @date_record = date_record
    @currency = currency
  end

  def perform
    total_balance + total_instrument_amounts
  end

  private

  def total_balance
    date_record.balances.includes(:account).map do |balance|
      date_record.exchange_rate.convert(balance.amount, currency)
    end.sum
  end

  def total_instrument_amounts
    date_record.instrument_amounts.includes(:instrument).map do |amount|
      price = date_record.exchange_rate.convert(amount.price, currency)
      price * amount.count
    end.sum
  end

  def instrument_price(amount)
    if amount.currency == currency
      amount.price
    else
      rate = date_record.exchange_rate.rate(amount.currency)
      Money.new(amount.price.cents * rate.to_f, currency)
    end
  end
end
