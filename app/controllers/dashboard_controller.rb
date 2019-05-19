class DashboardController < ApplicationController
  def show
    @dates = InstrumentPrice.distinct.order(date: :desc).pluck(:date)
    @instruments = Instrument.all
  end
end
