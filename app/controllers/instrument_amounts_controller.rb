class InstrumentAmountsController < ApplicationController
  CHART_START_DATE = Date.parse('2018-12-14').freeze
  
  before_action :set_instrument, only: %i[new create edit update destroy]
  before_action :set_amount, only: %i[edit update destroy]

  def index
    @chart_data = InstrumentPricesChart.result(start_date: CHART_START_DATE)
    @dates = InstrumentAmount.distinct.order(date: :desc).pluck(:date)
    @instruments = Instrument.all
  end

  def new
    @amount = @instrument.amounts.build
  end

  def edit
  end

  def create
    @amount = @instrument.amounts.build(amount_params)

    if @amount.save
      redirect_to :instrument_amounts, notice: 'Instrument amount was successfully created.'
    else
      render :new
    end
  end

  def update
    if @amount.update(amount_params)
      redirect_to :instrument_amounts, notice: 'Instrument amount was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @amount.destroy
    redirect_to :instrument_amounts, notice: 'Instrument amount was successfully destroyed.'
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:instrument_id])
  end

  def set_amount
    @amount = @instrument.amounts.find(params[:id])
  end

  def amount_params
    params.require(:instrument_amount).permit(:date, :count, :price)
  end
end
