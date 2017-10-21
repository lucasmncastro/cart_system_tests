Rails.application.routes.draw do
  get '/login',  to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post '/authenticate', to: 'sessions#create'

  get 'cart',   to: 'cart#index'
  get 'thanks', to: 'cart#thanks'
  get '/cart/add/:product_id', to: "cart#add", as: :add_cart
  get '/cart/outdated',        to: 'cart#outdated', as: :outdated_cart
  get '/cart/accept_changes',  to: 'cart#accept_changes', as: :accept_changes_cart
  get '/cart/reject_changes',  to: 'cart#reject_changes', as: :reject_changes_cart
  patch 'cart/update'

  root 'store#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
