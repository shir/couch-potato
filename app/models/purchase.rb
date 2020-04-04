# frozen_string_literal: true

# == Schema Information
#
# Table name: purchases
#
#  id             :bigint           not null, primary key
#  count          :integer          not null
#  price_cents    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date_record_id :bigint
#  instrument_id  :bigint
#
# Indexes
#
#  index_purchases_on_date_record_id_and_instrument_id  (date_record_id,instrument_id) UNIQUE
#
class Purchase < ApplicationRecord
  monetize :price_cents, with_model_currency: :currency

  delegate :currency, to: :instrument, allow_nil: true

  belongs_to :date_record, inverse_of: :purchases
  belongs_to :instrument, inverse_of: :purchases

  validates :date_record, presence: true
  validates :instrument, presence: true
  validates :date_record_id, uniqueness: { scope: :instrument_id }
  validates :count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
