Rails.application.routes.draw do

  %w[about affiliate_program terms privacy creator_appeal].each do |page|
    get page, controller: "info", action: page
  end

  devise_for :users
  get 'users/show'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end

  get 'search', to: 'notes#search'
  resources :notes do
    member do
      put "like", to: "notes#vote"
      get "verify", to: "notes#verify"
      get "request_verification",  to: "notes#request_verification"
    end
    resources :questions, only: [:create, :destroy] do
      resources :answers, only: [:create, :destroy]
    end
  end
  resources :images, only: [:create, :destroy]
  root 'notes#index'
end
