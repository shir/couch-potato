# frozen_string_literal: true

class TotalAmountChart < BaseQuery
  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result(currency)
    @result ||= {}.tap do |data|
      collect_date_records_data(data)
    end

    @result[currency]
  end

  def rebalances
    # if `@rebalances` are blank run `result` to build rebalances
    result unless @rebalances

    @rebalances
  end

  private

  def collect_date_records_data(data)
    data['RUB'] ||= {}
    data['USD'] ||= {}
    DateRecord.order(date: :asc).each do |dr|
      data['RUB'][dr.date] = dr.total_amounts['RUB'] || 0
      data['USD'][dr.date] = dr.total_amounts['USD'] || 0

      if dr.rebalance?
        @rebalances ||= []
        @rebalances << dr.date
      end
    end
  end
end
