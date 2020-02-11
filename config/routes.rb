Rails.application.routes.draw do

  %w[about affiliate_program terms privacy].each do |page|
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
    end
    resources :questions, only: [:create, :destroy]
  end
  root 'notes#index'
end
