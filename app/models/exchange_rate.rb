# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  CURRENCIES = %w[USD].freeze

  belongs_to :date_record, inverse_of: :exchange_rate

  validates :date_record, presence: true, uniqueness: true

  def usd
    rate('USD')
  end

  def rate(currency)
    rates[currency].sub(',', '.')
  end
end
