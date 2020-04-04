# frozen_string_literal: true

class TotalAmountChart < BaseQuery
  DEFAULT_CURRENCY = 'RUB'

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result
    @result ||= {}.tap do |data|
      collect_date_records_data(data)
    end
  end

  def rebalances
    # if `@rebalances` are blank run `result` to build rebalances
    result unless @rebalances

    @rebalances
  end

  private

  def collect_date_records_data(data)
    DateRecord.order(date: :asc).each do |dr|
      data[dr.date] = dr.total_amounts[DEFAULT_CURRENCY] || 0

      if dr.rebalance?
        @rebalances ||= []
        @rebalances << dr.date
      end
    end
  end
end
