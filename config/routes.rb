Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "users#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users do
    resources :posts do
      resources :post_ratings, only: [:create, :update, :destroy]
      resources :post_follows, only: [:create, :destroy]
    end
  end

  resources :users do
    resources :post_follows, only: [:index]
  end

  resources :posts, only: [] do
    resources :post_ratings, only: [:index]
    resources :comments, only: [:index,:create]
  end

  resources :comments, only: [:destroy]
end
