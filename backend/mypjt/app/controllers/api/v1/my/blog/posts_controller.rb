class Api::V1::My::Blog::PostsController < ApplicationController
  before_action :require_user
  before_action :set_post, only: [:show, :update, :destroy]
  
  def index
    posts = current_user.posts.includes(:user, :categories, :tags)
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
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post.destroy
    head :no_content
  end
  
  private
  
  def set_post
    @post = current_user.posts.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:title, :content, :published, category_ids: [], tag_ids: [])
  end
end