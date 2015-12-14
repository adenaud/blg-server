Rails.application.routes.draw do
  root 'home#index'
  resources :alerts
  resource :profile

  post '/login', to: 'profiles#login'
  get 'profile/:id', to: 'profiles#show'
end
