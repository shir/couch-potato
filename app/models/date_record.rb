# frozen_string_literal: true

# == Schema Information
#
# Table name: date_records
#
#  id            :bigint           not null, primary key
#  date          :date             not null
#  profits       :jsonb            not null
#  rebalance     :boolean          default(FALSE), not null
#  total_amounts :jsonb            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_date_records_on_date  (date) UNIQUE
#
class DateRecord < ApplicationRecord
  has_one :exchange_rate, inverse_of: :date_record, dependent: :destroy
  has_many :instrument_amounts, inverse_of: :date_record, dependent: :destroy
  has_many :balances, inverse_of: :date_record, dependent: :destroy
  has_many :purchases, inverse_of: :date_record, dependent: :destroy

  validates :date, presence: true, uniqueness: true

  accepts_nested_attributes_for :exchange_rate, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :balances, reject_if: proc{ |attrs| attrs[:amount].blank? }
  accepts_nested_attributes_for :instrument_amounts,
    reject_if: proc{ |attrs| attrs[:count].blank? && attrs[:price].blank? }

  class << self
    def previous(date)
      where('"date_records"."date" < ?', date).order(date: :desc).first
    end
  end

  def to_s
    I18n.l(date)
  end

  def to_param
    date.to_s
  end

  def fill_from(date_record)
    build_exchange_rate(rates: date_record.exchange_rate.rates) if date_record.exchange_rate
  end

  def total_amount(currency)
    Money.from_amount(total_amounts[currency] || 0, currency)
  end

  def profit(currency)
    Money.from_amount(profits[currency] || 0, currency)
  end

  def recalculate_total_amounts
    total_amounts['RUB'] = CalculateDateRecordTotal.perform(self, 'RUB').to_f.round(2)
    total_amounts['USD'] = CalculateDateRecordTotal.perform(self, 'USD').to_f.round(2)
    save
  end

  def recalculate_profits
    profits['RUB'] = CalculateDateRecordProfit.perform(self, 'RUB').to_f.round(2)
    profits['USD'] = CalculateDateRecordProfit.perform(self, 'USD').to_f.round(2)
    save
  end
end
