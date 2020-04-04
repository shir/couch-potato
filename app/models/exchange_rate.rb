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
