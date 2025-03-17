class ApplicationController < ActionController::API
  include ActionController::Cookies

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      render json: { error: "ログインしてください" }, status: :unauthorized
    end
  end


  def preflight
    head :ok
  end
end