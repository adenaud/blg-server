Rails.application.routes.draw do
  root 'home#index'
  resources :alerts
  resource :profile

  post '/login', to: 'profiles#login'
end
