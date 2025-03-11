class Api::V1::PostsController < ApplicationController
  before_action :require_user, except: [:index, :show]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]

  def index
    posts = Post.includes(:user, :categories, :tags)
                .order(created_at: :desc)
    
    render json: posts.as_json(
      include: {
        user: { only: [:id, :username] },
        categories: { only: [:id, :name] },
        tags: { only: [:id, :name] }
      }
    )
  end

  def show
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

  def create
    post = current_user.posts.build(post_params)
    
    if post.save
      # 카테고리 연결
      post.category_ids = params[:post][:category_ids] if params[:post][:category_ids]
      
      # 태그 연결
      post.tag_ids = params[:post][:tag_ids] if params[:post][:tag_ids]
      
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :published, category_ids: [], tag_ids: [])
  end

  def authorize_user
    unless @post.user_id == current_user.id
      render json: { error: "자신의 게시물만 수정/삭제할 수 있습니다." }, status: :forbidden
    end
  end

end
