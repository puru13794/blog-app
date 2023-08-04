Rails.application.routes.draw do
  resources :comments
  resources :posts
  devise_for :users
  root to: "home#index"
  post '/create_user'       => "app#create_user"
  post '/auth/login'        => "authentication#login"
  get '/get_posts'          => "app#get_posts"
  post '/create_post'       => "app#create_post"
  post '/edit_post'         => "app#edit_post"
  get '/get_comments'        => "app#get_comments"
  post '/add_comment'        => "app#add_comment"
end
