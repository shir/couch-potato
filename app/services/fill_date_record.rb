# frozen_string_literal: true

class FillDateRecord < BaseService
  attr_reader :date_record, :from_record

  def initialize(date_record, from_record = nil)
    @date_record = date_record
    @from_record = from_record
  end

  def perform
    fill_exchange_rate
    fill_balances
    fill_amounts
  end

  private

  def fill_exchange_rate
    return if date_record.exchange_rate

    date_record.build_exchange_rate(
      rates: from_record&.exchange_rate&.rates || {}
    )
  end

  def fill_balances
    Account.all.each do |account|
      date_record.balances.find_or_initialize_by(account_id: account.id) do |b|
        b.amount = from_record&.balances&.find_by(account_id: account.id)&.amount
      end
    end
  end

  def fill_amounts
    Instrument.visible.each do |instrument|
      date_record.instrument_amounts.find_or_initialize_by(instrument_id: instrument.id) do |ia|
        prev_ia = from_record&.instrument_amounts&.find_by(instrument_id: instrument.id)
        ia.count = prev_ia&.count
        ia.price = prev_ia&.price
      end
    end
  end
end
