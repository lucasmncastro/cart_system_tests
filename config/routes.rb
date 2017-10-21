Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post '/authenticate', to: 'sessions#create'

  get 'cart', to: 'cart#index'
  get '/cart/add/:product_id', to: "cart#add", as: :add_cart
  patch 'cart/update'
  patch 'cart/checkout'

  root 'store#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
