class InstrumentAmountsController < ApplicationController
  before_action :set_instrument, only: %i[new create edit update destroy]
  before_action :set_amount, only: %i[edit update destroy]

  def index
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
    if @amount.update(price_params)
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

  def set_price
    @amount = @instrument.amounts.find(params[:id])
  end

  def amount_params
    params.require(:instrument_amount).permit(:date, :amount)
  end
end
