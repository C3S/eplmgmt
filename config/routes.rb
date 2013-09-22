Eplmgmt::Application.routes.draw do

  resources :groups do
    resources :pads, only: [:index, :new, :create]
    resources :group_users, path: :users, only: [:index, :create]
  end

  resources :group_users, only: [:edit, :update, :destroy]
  resources :pads, only: [:edit, :update, :destroy]
  resources :pads, path: :p, only: [:show], format: false, id: /[A-Za-z0-9\.]+/

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  resources :users

  get '/p/:group/:pad', to: 'pads#show', as: 'group_pad'
  get '/pads', to: 'pads#index', as: 'pads'
end
