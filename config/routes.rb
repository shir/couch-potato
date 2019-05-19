Rails.application.routes.draw do
  resources :instruments, only: %i[index new create edit update destroy] do
    resources :instrument_amounts, only: %i[new create edit update destroy], path: :amounts
  end
  resources :instrument_prices, only: %i[index]
  resources :instrument_amounts, only: %i[index]

  root 'dashboard#show'
end
