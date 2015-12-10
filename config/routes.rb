Rails.application.routes.draw do
  root 'home#index'
  resources :alerts
  resource :profile
end
