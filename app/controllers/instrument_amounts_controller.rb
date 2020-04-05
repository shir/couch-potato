# frozen_string_literal: true

class InstrumentAmountsController < ApplicationController
  before_action :set_instrument, only: %i[new create]
  before_action :set_amount, only: %i[edit update destroy]

  def index
    @dates = InstrumentAmount.distinct.order(date: :desc).pluck(:date)
    @rates = ExchangeRate.where(date: @dates).index_by(&:date)
    @instruments = Instrument.visible
  end

  def new
    @amount = @instrument.amounts.build
  end

  def edit
  end

  def create
    @amount = @instrument.amounts.build(amount_params)

    if @amount.save
      UpdateDateRecordCalculations.perform(@amount.date_record)
      redirect_to date_amounts_path, notice: 'Instrument amount was successfully created.'
    else
      render :new
    end
  end

  def update
    if @amount.update(amount_params)
      UpdateDateRecordCalculations.perform(@amount.date_record)
      redirect_to date_amounts_path, notice: 'Instrument amount was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @amount.destroy
    UpdateDateRecordCalculations.perform(@amount.date_record)
    redirect_to date_amounts_path, notice: 'Instrument amount was successfully destroyed.'
  end

  private

  def set_instrument
    @instrument = Instrument.find(params[:instrument_id])
  end

  def set_amount
    @amount = InstrumentAmount.find(params[:id])
  end

  def amount_params
    params.require(:instrument_amount).permit(:date, :count, :price)
  end
end
