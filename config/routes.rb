# config/routes.rb
Rails.application.routes.draw do
  resources :products
  resources :sales, only: %i[index create show]
  resource :profile, only: %i[show]
  resources :password_resets, only: %i[new create edit update]

  resource :registration, only: %i[new create]
  resource :session, only: %i[new create destroy]

  root "home#index"
end