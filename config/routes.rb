Rails.application.routes.draw do
  resources :comments
  resources :posts
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"
  post '/auth/login'        => "authentication#login"
  get '/get_posts'          => "app#get_posts"
end
