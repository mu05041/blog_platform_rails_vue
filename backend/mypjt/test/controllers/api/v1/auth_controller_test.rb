require "test_helper"

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should signup" do
    assert_difference('User.count', 1) do
      post api_v1_signup_path, params: {
        user: {
          username: 'newuser',
          email: 'newuser@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    assert_response :created
    assert session[:user_id].present?
  end

  test "should login" do
    post api_v1_login_path, params: {
      email: @user.email,
      password: 'password'
    }
    assert_response :success
    assert session[:user_id].present?
  end

  test "should logout" do
    # 先にログイン
    post api_v1_login_path, params: {
      email: @user.email,
      password: 'password'
    }
    
    delete api_v1_logout_path
    assert_response :success
    assert_nil session[:user_id]
  end

end
