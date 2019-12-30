Rails.application.routes.draw do
  get 'search', to: 'notes#search'

  devise_for :users
  get 'users/show'

  resources :notes do
    member do
      get "like", to: "notes#upvote"
      get "dislike", to: "notes#downvote"
    end
    resources :comments
  end
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships
  root 'notes#index'
end
