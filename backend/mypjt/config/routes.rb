Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication Routing
      post '/signup', to: 'auth#signup'
      post '/login', to: 'auth#login'
      delete '/logout', to: 'auth#logout'
      
      # ユーザー別の記事を読み込む
      get '/:username/posts', to: 'posts#user_posts'
      get '/:username/posts/:id', to: 'posts#user_post'
      
      # 記事 CRUD (認証必要)
      resources :posts, only: [:create, :update, :destroy]
    end
  end

  match '*path', to: 'application#preflight', via: [:options]

end