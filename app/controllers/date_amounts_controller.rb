# frozen_string_literal: true

class DateAmountsController < ApplicationController
  def index
    @dates = InstrumentAmount.distinct.order(date: :desc).pluck(:date)
    @date_amounts = @dates.each_with_object({}){ |date, da| da[date] = DateAmount.new(date: date) }
    @instruments = Instrument.visible
    @accounts = Account.all
  end

  def new
    @date_amount = DateAmount.new(date: Time.zone.today)

    if (prev_date = InstrumentAmount.prev_date(Time.zone.today))
      @date_amount.fill_from(DateAmount.new(date: prev_date))
    end
  end

  def create
    @date_amount = DateAmount.new(params[:date_amount].to_unsafe_h)
    @date_amount.save

    redirect_to date_amounts_path
  end

  def edit
    @date_amount = DateAmount.new(date: Date.parse(params[:date]))
  end

  private

  def date_amount_params
    params.require(:date_amount).permit(:date)
  end
end
