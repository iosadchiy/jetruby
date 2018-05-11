Rails.application.routes.draw do
  root to: "appointments#index"
  resources :appointments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
