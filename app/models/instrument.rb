class Instrument < ApplicationRecord
  CURRENCIES = %w[USD RUB].freeze

  has_many :amounts, class_name: 'InstrumentAmount', inverse_of: :instrument, dependent: :destroy

  validates :ticker, presence: true
  validates :currency, presence: true, inclusion: { in: CURRENCIES }

  scope :visible, ->{ where(hidden: false) }

  def to_s
    ticker
  end
end
