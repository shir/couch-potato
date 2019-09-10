# frozen_string_literal: true

class BalancesController < ApplicationController
  before_action :set_account, only: %i[new create]
  before_action :set_balance, only: %i[edit update destroy]

  def new
    @balance = @account.balances.build
  end

  def edit
  end

  def create
    @balance = @account.balances.build(balance_params)

    if @balance.save
      redirect_to account_balances_path(@account), notice: 'Balance was successfully created.'
    else
      render :new
    end
  end

  def update
    if @balance.update(balance_params)
      redirect_to account_balances_path(@balance.account), notice: 'Balance was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /balances/1
  def destroy
    @balance.destroy
    redirect_to account_balances_path(@balance.account), notice: 'Balance was successfully destroyed.'
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def set_balance
    @balance = @account ? @account.balances.find(params[:id]) : Balance.find(params[:id])
  end

  def balance_params
    params.require(:balance).permit(:date, :amount)
  end
end
