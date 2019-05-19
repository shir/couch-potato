class InstrumentPricesController < ApplicationController
  before_action :set_instrument, only: %i[new create edit update destroy]
  before_action :set_price, only: %i[edit update destroy]

  def index
    @dates = InstrumentPrice.distinct.order(date: :desc).pluck(:date)
    @instruments = Instrument.all
  end

  def new
    @price = @instrument.prices.build
  end

  def edit
  end

  def create
    @price = @instrument.prices.build(price_params)

    if @price.save
      redirect_to :instrument_prices, notice: 'Instrument price was successfully created.'
    else
      render :new
    end
  end

  def update
    if @price.update(price_params)
      redirect_to :instrument_prices, notice: 'Instrument price was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @price.destroy
    redirect_to :instrument_prices, notice: 'Instrument price was successfully destroyed.'
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:instrument_id])
  end

  def set_price
    @price = @instrument.prices.find(params[:id])
  end

  def price_params
    params.require(:instrument_price).permit(:date, :price)
  end
end
