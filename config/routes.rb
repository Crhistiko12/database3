# config/routes.rb
Rails.application.routes.draw do
  resources :products
  resources :sales, only: %i[create]

  resource :registration, only: %i[new create]
  resource :session, only: %i[new create destroy]

  root "home#index"
end