Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication Routing
      post '/signup', to: 'auth#signup'
      post '/login', to: 'auth#login'
      delete '/logout', to: 'auth#logout'
      
      # 공개 블로그 조회
      namespace :blogs do
        scope ':username' do
          resources :posts, only: [:index, :show]
        end
      end
      
      # 내 블로그 관리 (인증 필요)
      namespace :my do
        namespace :blog do
          resources :posts
        end
      end
    end
  end
end