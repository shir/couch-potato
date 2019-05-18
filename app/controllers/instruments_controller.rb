class InstrumentsController < ApplicationController
  before_action :set_instrument, only: [:show, :edit, :update, :destroy]

  def index
    @instruments = Instrument.all
  end

  def show
  end

  def new
    @instrument = Instrument.new
  end

  def edit
  end

  def create
    @instrument = Instrument.new(instrument_params)

    if @instrument.save
      redirect_to @instrument, notice: 'Instrument was successfully created.'
    else
      render :new
    end
  end

  def update
    if @instrument.update(instrument_params)
      redirect_to @instrument, notice: 'Instrument was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @instrument.destroy

    redirect_to instruments_url, notice: 'Instrument was successfully destroyed.'
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:id])
  end

  def instrument_params
    params.require(:instrument).permit(:ticker)
  end
end
