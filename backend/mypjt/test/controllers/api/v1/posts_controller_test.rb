require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @post = posts(:one)
    @category = categories(:one)
    @tag = tags(:one)
    login_as(@user)
  end

  test "should get user posts" do
    get api_v1_user_posts_path(username: @user.username)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_not_empty json_response
    assert_equal @user.posts.count, json_response.size
  end
  
  test "should return 404 for non-existent user posts" do
    get api_v1_user_posts_path(username: "nonexistent")
    assert_response :not_found
  end
  
  test "should get user post detail" do
    get api_v1_user_post_path(username: @user.username, id: @post.id)
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @post.id, json_response["id"]
    assert_equal @post.title, json_response["title"]
  end
  
  test "should create post when authenticated" do
    assert_difference('Post.count') do
      post api_v1_posts_path, params: { 
        post: { 
          title: "New API Post", 
          content: "Content for API test", 
          published: true,
          category_ids: [@category.id],
          tag_ids: ["new_tag", @tag.name]
        } 
      }
    end
    
    assert_response :created
    new_post = Post.last
    assert_includes new_post.categories.pluck(:id), @category.id
    assert_includes new_post.tags.pluck(:name), "new_tag"
  end
  
  test "should not create post when unauthenticated" do
    logout
    
    assert_no_difference('Post.count') do
      post api_v1_posts_path, params: { 
        post: { 
          title: "Unauthorized Post", 
          content: "Test content" 
        } 
      }
    end
    
    assert_response :unauthorized
  end
  
  test "should update own post" do
    patch api_v1_post_path(@post), params: { 
      post: { 
        title: "Updated Title",
        category_ids: [@category.id],
        tag_ids: ["updated_tag"]
      } 
    }
    
    assert_response :success
    @post.reload
    assert_equal "Updated Title", @post.title
    assert_includes @post.tags.pluck(:name), "updated_tag"
  end
  
  test "should not update another user's post" do
    other_post = @other_user.posts.first
    
    patch api_v1_post_path(other_post), params: { 
      post: { title: "Should Not Update" } 
    }
    
    assert_response :forbidden
    assert_not_equal "Should Not Update", other_post.reload.title
  end
  
  test "should delete own post" do
    assert_difference('Post.count', -1) do
      delete api_v1_post_path(@post)
    end
    
    assert_response :no_content
  end
  
  test "should not delete another user's post" do
    other_post = @other_user.posts.first
    
    assert_no_difference('Post.count') do
      delete api_v1_post_path(other_post)
    end
    
    assert_response :forbidden
  end
end
