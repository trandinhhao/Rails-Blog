Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "users#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users do
    resources :posts do
      resources :post_ratings
      resources :post_follows, only: [:new, :create, :destroy]
    end
  end

  resources :users do
    resources :post_follows, only: [:index]
  end

  resources :posts, only: [] do
    resources :comments
  end

  resources :comments, only: [:destroy]
end
