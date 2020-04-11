# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id             :bigint           not null, primary key
#  rates          :jsonb            not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date_record_id :bigint           not null
#
# Indexes
#
#  index_exchange_rates_on_date_record_id  (date_record_id)
#
class ExchangeRate < ApplicationRecord
  DEFAULT_CURRENCY = 'RUB'
  CURRENCIES = %w[USD].freeze

  belongs_to :date_record, inverse_of: :exchange_rate

  validates :date_record, presence: true, uniqueness: true

  def usd
    rate('USD')
  end

  def rate(currency)
    rates[currency].sub(',', '.')
  end

  def convert(money, to_currency)
    return null unless money
    return money if money.currency.to_s == to_currency

    # Because I use only two currencies for now then
    # only default and non defualt currencies may be passed
    # and if money.currency is equal default currency
    # then I convert from RUB to USD
    # otherwise I convert from USD to RUB
    rate =
      if money.currency.to_s == DEFAULT_CURRENCY
        1.0 / rate(to_currency).to_f
      else
        rate(money.currency.to_s).to_f
      end

    Money.new(money.cents * rate, to_currency)
  end
end
