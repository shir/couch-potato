# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[edit update destroy]

  def index
    @accounts = Account.all.order(name: :asc)
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to :accounts, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def update
    if @account.update(account_params)
      redirect_to :accounts, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @account.destroy

    redirect_to :accounts, notice: 'Account was successfully destroyed.'
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :currency, :hidden)
  end
end
