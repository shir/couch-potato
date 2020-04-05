# frozen_string_literal: true

class DateRecordsController < ApplicationController
  before_action :set_date_record, only: %i[edit update destroy]

  def index
    @page = DateRecordsPage.new(params)
  end

  def new
    @date_record = DateRecord.new(date: Time.zone.today)

    if (prev_record = DateRecord.previous(@date_record.date)) # rubocop:disable Style/GuardClause
      FillDateRecord.perform(@date_record, prev_record)
    end
  end

  def create
    @date_record = DateRecord.new(date_record_params)
    if @date_record.save
      UpdateDateRecordCalculations.perform(@date_record)
      redirect_to date_records_path, notice: 'Date record has been created.'
    else
      FillDateRecord.perform(@date_record)
      render :new
    end
  end

  def edit
    FillDateRecord.perform(@date_record)
  end

  def update
    if @date_record.update(date_record_params)
      UpdateDateRecordCalculations.perform(@date_record)
      redirect_to date_records_path, notice: 'Date record has been updated.'
    else
      Rails.logger.debug "errors: #{@date_record.errors.full_messages.inspect}"
      render :edit
    end
  end

  def destroy
    if @date_record.destroy
      redirect_to date_records_path, notice: 'Date record has been removed.'
    else
      redirect_to(
        edit_date_record_path(@date_record),
        alert: "Can't remove date record: #{@date_record.errors.full_messages.join(', ')}"
      )
    end
  end

  private

  def set_date_record
    @date_record = DateRecord.find_by(date: params[:date])
  end

  def date_record_params
    params.require(:date_record).permit(
      :date, :rebalance,
      exchange_rate_attributes:      [:id, rates: {}],
      balances_attributes:           %i[id account_id amount],
      instrument_amounts_attributes: %i[id instrument_id count price],
    )
  end
end
