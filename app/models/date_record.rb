# frozen_string_literal: true

class DateRecord < ApplicationRecord
  has_one :exchange_rate, inverse_of: :date_record, dependent: :destroy
  has_many :instrument_amounts, inverse_of: :date_record, dependent: :destroy
  has_many :balances, inverse_of: :date_record, dependent: :destroy

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
end
