# frozen_string_literal: true

# == Schema Information
#
# Table name: instrument_amounts
#
#  id             :bigint           not null, primary key
#  count          :integer          not null
#  price_cents    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date_record_id :bigint           not null
#  instrument_id  :bigint           not null
#
# Indexes
#
#  index_instrument_amounts_on_date_record_id  (date_record_id)
#
class InstrumentAmount < ApplicationRecord
  SPLITS = {
    'FXRU' => {
      divide: 10,
      date:   Date.parse('2018-12-14'),
    },
  }.freeze

  belongs_to :date_record, inverse_of: :instrument_amounts
  belongs_to :instrument, inverse_of: :amounts

  validates :date_record, presence: true
  validates :instrument, presence: true
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :date_record_id, uniqueness: { scope: :instrument_id }

  monetize :price_cents, with_model_currency: :currency

  delegate :currency, to: :instrument, allow_nil: true

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
    return price if date_record.date >= split[:date]

    return price / split[:divide]
  end
end
