class InstrumentPrice < ApplicationRecord
  belongs_to :instrument, inverse_of: :prices

  validates :instrument, presence: true
  validates :date, presence: true
  validates :price, presence: true

  monetize :price_cents, with_model_currency: :currency

  delegate :currency, to: :instrument
end
