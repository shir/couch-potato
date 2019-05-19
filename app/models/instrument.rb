class Instrument < ApplicationRecord
  CURRENCIES = %w[USD RUB].freeze

  has_many :prices, class_name: 'InstrumentPrice', inverse_of: :instrument, dependent: :destroy
  has_many :amounts, class_name: 'InstrumentAmount', inverse_of: :instrument, dependent: :destroy

  validates :ticker, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }

  def to_s
    ticker
  end
end
