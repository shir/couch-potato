# frozen_string_literal: true

class InstrumentAmount < ApplicationRecord
  SPLITS = {
    'FXRU' => {
      divide: 10,
      date:   Date.parse('2018-12-14'),
    },
  }.freeze

  belongs_to :instrument, inverse_of: :amounts

  validates :date, presence: true
  validates :instrument, presence: true
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  monetize :price_cents, with_model_currency: :currency

  delegate :currency, to: :instrument, allow_nil: true

  scope :prev, ->(date){ where('"instrument_amounts"."date" < ?', date).order }

  class << self
    def prev_date(date)
      where('"instrument_amounts"."date" < ?', date).order(date: :desc).first&.date
    end
  end

  def total
    price * count
  end

  # This method reduce price to same value because some instruments
  # may be splitted
  def absolute_price
    return nil if price.blank?
    return price unless SPLITS.keys.include?(instrument&.ticker)

    split = SPLITS[instrument.ticker]
    return price if date >= split[:date]

    return price / split[:divide]
  end
end
