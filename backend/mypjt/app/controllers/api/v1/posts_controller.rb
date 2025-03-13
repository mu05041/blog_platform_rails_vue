class Api::V1::PostsController < ApplicationController
  before_action :require_user, except: [:user_posts, :user_post]
  before_action :set_post, only: [:update, :destroy]
  before_action :set_user_post, only: [:user_post]
  before_action :authorize_user, only: [:update, :destroy]
  
  # 사용자별 게시물 목록 (GET api/v1/:username/posts)
  def user_posts
    user = User.find_by(username: params[:username])
    
    if user
      posts = user.posts.includes(:categories, :tags)
                  .order(created_at: :desc)
      
      render json: posts.as_json(
        include: {
          user: { only: [:id, :username] },
          categories: { only: [:id, :name] },
          tags: { only: [:id, :name] }
        }
      )
    else
      render json: { error: "사용자를 찾을 수 없습니다." }, status: :not_found
    end
  end
  
  # 사용자별 게시물 상세 (GET api/v1/:username/posts/:id)
  def user_post
    render json: @post.as_json(
      include: {
        user: { only: [:id, :username] },
        categories: { only: [:id, :name] },
        tags: { only: [:id, :name] },
        comments: {
          include: {
            user: { only: [:id, :username] }
          }
        }
      }
    )
  end
  
  # 게시물 생성 (POST api/v1/posts)
  def create
    post = current_user.posts.build(post_params)
    
    if post.save
      # 카테고리 연결
      post.category_ids = params[:post][:category_ids] if params[:post][:category_ids]
      
    # 태그 연결
      if params[:post][:tag_ids].present?
        post.tag_ids = params[:post][:tag_ids].map { |tag_name| Tag.find_or_create_by(name: tag_name).id }
    end
      
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # 게시물 수정 (PUT api/v1/posts/:id)
  def update
    if @post.update(post_params)
      # 카테고리와 태그 업데이트 추가
      @post.category_ids = params[:post][:category_ids] if params[:post][:category_ids]
      
    # 콘텐츠에서 해시태그 추출 및 태그 연결
      extracted_tags = extract_hashtags(@post.content)
      @post.tag_ids = extracted_tags.map { |tag_name| Tag.find_or_create_by(name: tag_name).id } if extracted_tags.any?
      
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # 게시물 삭제 (DELETE api/v1/posts/:id)
  def destroy
    @post.destroy
    head :no_content
  end
  
  private

  def set_post
    @post = Post.find(params[:id])
  end
  
  def set_user_post
    user = User.find_by(username: params[:username])
    
    if user
      @post = user.posts.includes(:user, :categories, :tags, comments: :user)
                 .find_by(id: params[:id])
      
      unless @post
        render json: { error: "게시물을 찾을 수 없습니다." }, status: :not_found
      end
    else
      render json: { error: "사용자를 찾을 수 없습니다." }, status: :not_found
    end
  end
  
  def post_params
    params.require(:post).permit(:title, :content, :published)
  end
  
  def authorize_user
    unless @post.user_id == current_user.id
      render json: { error: "자신의 게시물만 수정/삭제할 수 있습니다." }, status: :forbidden
    end
  end
end