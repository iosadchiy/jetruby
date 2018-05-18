Rails.application.routes.draw do
  root to: "appointments#index"
  resources :appointments

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  resources :sessions, only: [:new, :create, :destroy]
end
