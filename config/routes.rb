# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts, only: %i[index new create edit update destroy] do
    resources :balances, except: %i[index show], shallow: true
  end
  resources :instruments, only: %i[index new create edit update destroy] do
    resources :instrument_amounts, except: %i[index show], path: :amounts, shallow: true
  end
  resources :date_records, except: %i[show], param: :date

  root 'dashboard#show'
end
