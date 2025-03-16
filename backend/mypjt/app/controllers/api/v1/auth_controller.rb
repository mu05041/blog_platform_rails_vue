class Api::V1::AuthController < ApplicationController
    def signup
        user = User.new(user_params)
        
        if user.save
          session[:user_id] = user.id
          render json: { user: user.as_json(except: [:password_digest]), message: "ユーザー登録成功" }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      def login
        user = User.find_by(email: params[:email])
        
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          render json: { user: user.as_json(except: [:password_digest]), message: "ログイン成功" }
        else
          render json: { error: "メールアドレスまたはパスワードが正しくありません。" }, status: :unauthorized
        end
      end
    
      def logout
        session[:user_id] = nil
        render json: { message: "ログアウト成功" }
      end
    
      private
    
      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
end
