# frozen_string_literal: true

class DateAmount < ApplicationFormObject
  attr_accessor :date

  validates :date, presence: true

  def initialize(params = {})
    define_rate_methods
    define_count_methods
    define_price_methods

    super convert_date_params(params, :date)
  end

  def fill_from(date_amount)
    return unless date

    fill_rates_from(date_amount)
    fill_counts_and_prices_from(date_amount)
  end

  def instruments
    @instruments ||= Instrument.visible
  end

  def tickers
    @tickers ||= instruments.map(&:ticker)
  end

  def instrument_amounts
    @instrument_amounts ||= InstrumentAmount
      .where(date: date)
      .includes(:instrument)
      .index_by{ |ia| ia.instrument.ticker }
  end

  def counts
    @counts ||= tickers.each_with_object({}) do |t, c|
      c[t] = instrument_amounts[t]&.count
    end
  end

  def prices
    @prices ||= tickers.each_with_object({}) do |t, p|
      p[t] = instrument_amounts[t]&.price
    end
  end

  def rates
    @rates ||= ExchangeRate.find_by(date: date)&.rates || {}
  end

  def rate_name(currency)
    "#{currency}_rate"
  end

  def count_name(ticker)
    "#{ticker}_count"
  end

  def price_name(ticker)
    "#{ticker}_price"
  end

  def save
    er = ExchangeRate.find_or_initialize_by(date: date)
    er.rates = rates
    er.save

    instruments.each do |instrument|
      count = counts[instrument.ticker]
      price = prices[instrument.ticker]
      next if count.blank? || price.blank?

      ia = InstrumentAmount.find_or_initialize_by(instrument: instrument, date: date)
      ia.count = count
      ia.price = price
      ia.save
    end
  end

  private

  def define_rate_methods
    ExchangeRate::CURRENCIES.each do |currency|
      self.class.define_method(
        rate_name(currency),
        proc{ rates[currency] }
      )
      self.class.define_method(
        "#{rate_name(currency)}=",
        proc{ |rate| rates[currency] = rate.presence && Monetize.parse(rate).to_f }
      )
    end
  end

  def define_count_methods
    tickers.each do |ticker|
      self.class.define_method(
        count_name(ticker),
        proc{ counts[ticker] }
      )
      self.class.define_method(
        "#{count_name(ticker)}=",
        proc{ |count| counts[ticker] = count }
      )
    end
  end

  def define_price_methods
    tickers.each do |ticker|
      self.class.define_method(
        price_name(ticker),
        proc{ prices[ticker] }
      )
      self.class.define_method(
        "#{price_name(ticker)}=",
        proc{ |price| prices[ticker] = price }
      )
    end
  end

  def fill_rates_from(date_amount)
    ExchangeRate::CURRENCIES.each do |currency|
      next if rates[currency]

      rates[currency] = date_amount.rates[currency]
    end
  end

  def fill_counts_and_prices_from(date_amount)
    tickers.each do |ticker|
      next if counts[ticker]

      counts[ticker] = date_amount.counts[ticker]
      prices[ticker] = date_amount.prices[ticker]
    end
  end

  def convert_date_params(params, date_key)
    date_key = date_key.to_s
    params.dup.tap do |p|
      year  = p.delete("#{date_key}(1i)")
      month = p.delete("#{date_key}(2i)")
      day   = p.delete("#{date_key}(3i)")

      next if year.blank? || month.blank? || day.blank?

      p[date_key] = Date.new(year.to_i, month.to_i, day.to_i)
    end
  end
end
