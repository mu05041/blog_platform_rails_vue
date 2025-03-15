# test/helpers/authentication_helper.rb
module AuthenticationHelper
    def login_as(user)
      post api_v1_login_path, params: {
        email: user.email,
        password: 'default_password'
      }
    end
  
    def logout
      delete api_v1_logout_path
    end
  end

  module ApiV1RoutesHelper
    def api_v1_user_posts_path(username:)
      "/api/v1/#{username}/posts"
    end
  
    def api_v1_user_post_path(username:, id:)
      "/api/v1/#{username}/posts/#{id}"
    end
  end