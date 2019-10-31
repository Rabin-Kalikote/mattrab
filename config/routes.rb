Rails.application.routes.draw do
  get 'users/show'
  get 'search', to: 'notes#search'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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
