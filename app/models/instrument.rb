class Instrument < ApplicationRecord
  CURRENCIES = %w[USD RUB].freeze

  validates :ticker, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }

  def to_s
    ticker
  end
end
