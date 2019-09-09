# frozen_string_literal: true

class DateAmount < ApplicationFormObject
  attr_accessor :date

  validates :date, presence: true

  def initialize(params = {})
    define_rate_methods
    define_balance_methods
    define_amount_methods

    super convert_date_params(params, :date)
  end

  def fill_from(date_amount)
    return unless date

    fill_rates_from(date_amount)
    fill_balances_from(date_amount)
    fill_amounts_from(date_amount)
  end

  def accounts
    @accounts ||= Account.all
  end

  def instruments
    @instruments ||= Instrument.visible
  end

  def balances
    @balances ||= Balance.where(date: date).index_by(&:account_id)
  end

  def amounts
    @amounts ||= InstrumentAmount
      .where(date: date)
      .includes(:instrument)
      .index_by{ |ia| ia.instrument.ticker }
  end

  def rates
    @rates ||= ExchangeRate.find_by(date: date)&.rates || {}
  end

  def balance_name(account)
    "account_#{account.id}_balance"
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
    save_rates
    save_balances
    save_amounts
  end

  private

  def save_rates
    er = ExchangeRate.find_or_initialize_by(date: date)
    er.rates = rates
    er.save
  end

  def save_balances
    balances.each do |_account_id, balance|
      balance.date = date
      next if balance.save

      Rails.logger.error "Error on save balance #{balance.inspect}: #{balance.errors.full_messages.inspect}"
    end
  end

  def save_amounts
    amounts.each do |_ticker, amount|
      amount.date = date
      next if amount.save

      Rails.logger.error "Error on save amount #{amount.inspect}: #{amount.errors.full_messages.inspect}"
    end
  end

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

  def define_balance_methods
    accounts.each do |account|
      self.class.define_method(balance_name(account), balance_getter(account))
      self.class.define_method("#{balance_name(account)}=", balance_setter(account))
    end
  end

  def define_amount_methods # rubocop:disable Metrics/AbcSize
    instruments.each do |instrument|
      self.class.define_method(count_name(instrument.ticker), count_getter(instrument))
      self.class.define_method("#{count_name(instrument.ticker)}=", count_setter(instrument))
      self.class.define_method(price_name(instrument.ticker), price_getter(instrument))
      self.class.define_method("#{price_name(instrument.ticker)}=", price_setter(instrument))
    end
  end

  def balance_getter(account)
    proc{ balances[account.id]&.amount }
  end

  def balance_setter(account)
    proc{ |amount|
      balance = balances[account.id] ||= account.balances.build
      balance.amount = amount
    }
  end

  def count_getter(instrument)
    proc{ amounts[instrument.ticker]&.count }
  end

  def count_setter(instrument)
    proc{ |count|
      amount = amounts[instrument.ticker] ||= instrument.amounts.build
      amount.count = count
    }
  end

  def price_getter(instrument)
    proc{ amounts[instrument.ticker]&.price }
  end

  def price_setter(instrument)
    proc{ |price|
      amount = amounts[instrument.ticker] ||= instrument.amounts
      amount.price = price
    }
  end

  def fill_rates_from(date_amount)
    ExchangeRate::CURRENCIES.each do |currency|
      next if rates[currency]

      rates[currency] = date_amount.rates[currency]
    end
  end

  def fill_balances_from(date_amount)
    accounts.each do |account|
      next unless (da = date_amount.balances[account.id])

      balances[account.id] ||= account.balances.build(
        amount: da.amount,
      )
    end
  end

  def fill_amounts_from(date_amount)
    instruments.each do |instrument|
      next unless (da = date_amount.amounts[instrument.ticker])

      amounts[instrument.ticker] ||= instrument.amounts.build(
        count: da.count,
        price: da.price,
      )
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
