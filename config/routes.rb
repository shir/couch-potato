Rails.application.routes.draw do
  resources :instruments , only: %i[index new create edit update destroy]
end
