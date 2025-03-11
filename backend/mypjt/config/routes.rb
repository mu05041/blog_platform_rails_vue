Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication Routing
      post '/signup', to: 'auth#signup'
      post '/login', to: 'auth#login'
      delete '/logout', to: 'auth#logout'
      
      # Blog Routing
      resources :posts
      resources :categories, only: [:index, :show]
      resources :tags, only: [:index, :show]
      resources :comments, only: [:create, :update, :destroy]
    end
  end

end
