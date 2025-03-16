class Api::V1::PostsController < ApplicationController
  before_action :require_user, except: [:user_posts, :user_post]
  before_action :set_post, only: [:update, :destroy]
  before_action :set_user_post, only: [:user_post]
  before_action :authorize_user, only: [:update, :destroy]
  
  # ユーザー別投稿リスト (GET api/v1/:username/posts)
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
      render json: { error: "ユーザーが見つかりません。" }, status: :not_found
    end
  end
  
  # ユーザー別投稿詳細 (GET api/v1/:username/posts/:id)
  def user_post
    render json: @post.as_json(
      include: {
        user: { only: [:id, :username] },
        categories: { only: [:id, :name] },
        tags: { only: [:id, :name] },
        }
    )
  end
  
  # 記事作成 (POST api/v1/posts)
  def create
    post = current_user.posts.build(post_params)
    
    if post.save
      # カテゴリの紐付け
      post.category_ids = params[:post][:category_ids] if params[:post][:category_ids]
      
    # タグの紐付け
      if params[:post][:tag_ids].present?
        post.tag_ids = params[:post][:tag_ids].map { |tag_name| Tag.find_or_create_by(name: tag_name).id }
    end
      
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # 記事修正 (PUT api/v1/posts/:id)
  def update
    if @post.update(post_params)
      # カテゴリーとタグの更新
      @post.category_ids = params[:post][:category_ids] if params[:post][:category_ids]
      
    # タグの紐付け
    if params[:post][:tag_ids].present?
      @post.tag_ids = params[:post][:tag_ids].map { |tag_name| Tag.find_or_create_by(name: tag_name).id }
    end
    
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  # 記事削除 (DELETE api/v1/posts/:id)
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
      @post = user.posts.includes(:user, :categories, :tags)
                 .find_by(id: params[:id])
      
      unless @post
        render json: { error: "記事が見つかりません。" }, status: :not_found
      end
    else
      render json: { error: "ユーザーが見つかりません。" }, status: :not_found
    end
  end
  
  def post_params
    params.require(:post).permit(:title, :content, :published)
  end
  
  def authorize_user
    unless @post.user_id == current_user.id
      render json: { error: "自分の記事のみ編集・削除できます。" }, status: :forbidden
    end
  end
end