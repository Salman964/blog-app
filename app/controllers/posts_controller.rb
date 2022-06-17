# frozen_string_literal: true

class PostsController < ApplicationController   
  def index
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @post
      # redirect_to "http://localhost:3000/posts"
    else
      render :status => 404
    end
  end

  def pending
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def rejected
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def post_params
    params.require(:post).permit(:caption, :image)
  end
end
