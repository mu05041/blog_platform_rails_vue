Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication Routing
      post '/signup', to: 'auth#signup'
      post '/login', to: 'auth#login'
      delete '/logout', to: 'auth#logout'
      
      # 사용자 별 블로그 게시물 조회
      get '/:username/posts', to: 'posts#user_posts'
      get '/:username/posts/:id', to: 'posts#user_post'
      
      # 게시물 CRUD (인증 필요)
      resources :posts, only: [:create, :update, :destroy]
    end
  end
end