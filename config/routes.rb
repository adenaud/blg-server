Rails.application.routes.draw do
  root 'home#index'
  resources :alerts
  resource :profiles

  post '/login', to: 'profiles#login'
  get '/profile/:id', to: 'profiles#show'
  put '/profile/:id', to: 'profiles#update'

  post '/operator/login', to: 'operator#login'
end
