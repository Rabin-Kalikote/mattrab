Rails.application.routes.draw do
  %w[about faqs affiliate_program terms privacy creator_appeal].each do |page|
    get page, controller: "info", action: page
  end

  devise_for :users
  get 'users/show'
  resources :users do
    resources :categorizations
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

  get 'search', to: 'searches#search'
  get 'home', to: 'notes#home'
  resources :notes do
    member do
      put "thank", to: "notes#vote"
      get "verify", to: "notes#verify"
      get "request_verification",  to: "notes#request_verification"
    end
    resources :questions, only: [:create, :destroy] do
      resources :answers, only: [:create, :destroy]
    end
  end
  resources :questions do
    member do
      put "vote", to: "questions#vote"
    end
    resources :answers, only: [:create, :edit, :update, :destroy] do
      put "vote", to: "answers#vote"
    end
  end
  resources :images, only: [:create, :destroy]
  root 'notes#home'
end
