Rails.application.routes.draw do
  resources :instruments, only: %i[index new create edit update destroy] do
    resources :instrument_amounts, only: %i[new create], path: :amounts
  end
  resources :instrument_amounts, only: %i[index edit update destroy]

  root 'dashboard#show'
end
