# frozen_string_literal: true

class DateRecordsPage
  def date_records
    @date_records ||= DateRecord.order(date: :desc)
  end

  def currencies
    ExchangeRate::CURRENCIES
  end

  def instruments
    @instruments ||= Instrument.visible
  end

  def accounts
    @accounts ||= Account.visible
  end

  def exchange_rate(date_record, currency)
    er = exchange_rates[date_record.id]
    er ? er.rates[currency] : nil
  end

  def balance(date_record, account)
    balances.dig(date_record.id, account.id)
  end

  def amount(date_record, instrument)
    amounts.dig(date_record.id, instrument.id)
  end

  private

  def exchange_rates
    @exchange_rates ||= ExchangeRate.where(date_record_id: @date_records.ids).index_by(&:date_record_id)
  end

  def balances
    @balances ||= Balance
      .where(date_record_id: @date_records.ids)
      .preload(:account)
      .each_with_object({}) do |b, a|
      a[b.date_record_id] ||= {}
      a[b.date_record_id][b.account_id] = b
    end
  end

  def amounts
    @amounts ||= InstrumentAmount
      .where(date_record_id: @date_records.ids)
      .preload(:instrument)
      .each_with_object({}) do |ia, a|
      a[ia.date_record_id] ||= {}
      a[ia.date_record_id][ia.instrument_id] = ia
    end
  end
end
