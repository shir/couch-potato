class DashboardController < ApplicationController
  PRICE_CHART_START_DATE = Date.parse('2018-12-14').freeze

  def show
    @total_chart_data  = TotalAmountChart.result
    @prices_chart_data = InstrumentPricesChart.result
  end
end
