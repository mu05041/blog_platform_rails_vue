class Api::V1::AuthController < ApplicationController
    def signup
        user = User.new(user_params)
        
        if user.save
          session[:user_id] = user.id
          render json: { user: user.as_json(except: [:password_digest]), message: "회원가입 성공" }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      def login
        user = User.find_by(email: params[:email])
        
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          render json: { user: user.as_json(except: [:password_digest]), message: "로그인 성공" }
        else
          render json: { error: "이메일 또는 비밀번호가 잘못되었습니다." }, status: :unauthorized
        end
      end
    
      def logout
        session[:user_id] = nil
        render json: { message: "로그아웃 성공" }
      end
    
      private
    
      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
end
