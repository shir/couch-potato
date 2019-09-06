# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  CURRENCIES = %w[USD].freeze

  validates :date, presence: true

  def usd
    rates['USD']
  end
end
