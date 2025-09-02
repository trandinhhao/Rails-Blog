Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "users#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users do
    resources :posts
  end

  resources :posts do
    resources :comments
  end

end
