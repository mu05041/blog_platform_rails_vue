class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  def setup
    @user = users(:one)
    @other_user = users(:two)
    @post = @user.posts.create!(title: "Test Post", content: "Test Content")

    post api_v1_login_path, params: {
      email: @user.email, 
      password: 'password'
    }
    assert_response :success
  end

  test "should get user posts" do
    get "/api/v1/#{@user.username}/posts"
    assert_response :success
  end

  test "should get user post detail" do
    get "/api/v1/#{@user.username}/posts/#{@post.id}"
    assert_response :success
  end

  test "should create post when authenticated" do
    assert_difference('Post.count', 1) do
      post api_v1_posts_path, params: {
        post: { 
          title: "New Post", 
          content: "New Content" 
        }
      }
    end
    assert_response :created
  end

  test "should update own post" do
    put "/api/v1/posts/#{@post.id}", params: {
      post: {
        title: "Updated Title"
      }
    }
    assert_response :success
  end

  test "should delete own post" do
    assert_difference('Post.count', -1) do
      delete "/api/v1/posts/#{@post.id}"
    end
    assert_response :no_content
  end
end