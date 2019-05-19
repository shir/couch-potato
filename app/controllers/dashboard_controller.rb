class DashboardController < ApplicationController
  PRICE_CHART_START_DATE = Date.parse('2018-12-14').freeze

  def show
    @prices_chart_data = InstrumentPricesChart.result
  end
end
