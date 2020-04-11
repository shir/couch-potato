# frozen_string_literal: true

class CalculateDateRecordProfit < BaseService
  attr_reader :date_record, :currency

  def initialize(date_record, currency)
    @date_record = date_record
    @currency = currency
  end

  def perform
    date_record.instrument_amounts.includes(:instrument).map do |ia|
      profit_for_instrument_amount(ia)
    end.sum
  end

  private

  def profit_for_instrument_amount(instrument_amount)
    return make_money(0) if instrument_amount.count.zero?

    count = instrument_amount.absolute_count
    profit = instrument_amount_purchases(instrument_amount).map do |purchase|
      next 0 if count <= 0

      position_count = count >= purchase.count ? purchase.count : count
      count -= position_count

      ia_price = convert(instrument_amount.absolute_price, date_record)
      purchase_price = convert(purchase.price, purchase.date_record)

      (ia_price - purchase_price) * position_count
    end.sum

    make_money(profit)
  end

  def instrument_amount_purchases(instrument_amount)
    instrument_amount
      .instrument
      .purchases
      .joins(:date_record)
      .where(DateRecord.arel_table[:date].lt(date_record.date))
      .order(DateRecord.arel_table[:date].desc)
  end

  def profit_for_purchase(instrument_amount, purchase)
    (instrument_amount.price - purchase.price) * purchase.count
  end

  def convert(price, date_record)
    date_record.exchange_rate.convert(price, currency)
  end

  def make_money(value)
    return value if value.is_a?(Money)

    Money.from_amount(value, currency)
  end
end
