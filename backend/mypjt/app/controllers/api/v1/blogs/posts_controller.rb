class Api::V1::Blogs::PostsController < ApplicationController
  before_action :set_user
  
  def index
    posts = @user.posts.includes(:user, :categories, :tags)
                .where(published: true)
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
    post = @user.posts.includes(:user, :categories, :tags, comments: [:user])
               .where(published: true)
               .find(params[:id])
    
    render json: post.as_json(
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
  
  private
  
  def set_user
    @user = User.find_by!(username: params[:username])
  end
end