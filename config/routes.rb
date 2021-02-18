Rails.application.routes.draw do

  get '/sitemap', to: redirect("https://#{ENV.fetch('S3_BUCKET_NAME')}.s3.amazonaws.com/sitemaps/sitemap.xml.gz")

  %w[about faqs affiliate_program terms privacy creator_appeal admin_action].each do |page|
    get page, controller: "info", action: page
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users' }
  get 'users/show'
  resources :users do
    resources :categorizations
    member do
      get :following, :followers
      get "change_role",  to: "users#change_role"
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
    collection do
      post :import
    end
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
