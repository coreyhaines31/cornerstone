class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.published.order(published_at: :desc).page(params[:page])
    @posts = @posts.where(category: params[:category]) if params[:category].present?
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
  end

  def show
    if !@post.published? && (!user_signed_in? || @post.author != current_user)
      raise ActiveRecord::RecordNotFound
    end
  end

  def new
    @post = current_user.posts.build
    authorize @post
  end

  def create
    @post = current_user.posts.build(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find_by!(slug: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :slug, :content, :excerpt, :meta_description,
                                  :category, :tags, :published_at)
  end
end