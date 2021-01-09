# frozen_string_literal: true

class ProfitChart < BaseQuery
  DEFAULT_CURRENCY = 'RUB'

  attr_reader :start_date

  def initialize(start_date: nil)
    @start_date = start_date
  end

  def result(currency)
    build_result unless @result

    @result[currency]
  end

  def rebalances
    # if `@rebalances` are blank run `result` to build rebalances
    unless @rebalances
      @rebalances ||= []
      build_result
    end

    @rebalances
  end

  private

  def build_result
    @result = {}.tap do |data|
      collect_date_records_data(data)
    end
  end

  def collect_date_records_data(data)
    data['RUB'] ||= {}
    data['USD'] ||= {}
    DateRecord.order(date: :asc).each do |dr|
      data['RUB'][dr.date] = dr.profits['RUB'] || 0
      data['USD'][dr.date] = dr.profits['USD'] || 0

      if dr.rebalance?
        @rebalances ||= []
        @rebalances << dr.date
      end
    end
  end
end
