Rails.application.routes.draw do
  resources :instruments, only: %i[index new create edit update destroy] do
    resources :instrument_prices, only: %i[index new create edit update destroy], path: :prices
  end

  root 'dashboard#show'
end
