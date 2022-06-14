class ModeratorsController < ApplicationController
  def index
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def approved
    @post = Post.find params[:id]
    @post.update_attribute(:post_status, 1)
    @post.save
  end

  def rejected
    @post = Post.find params[:id]
    @post.update_attribute(:post_status, 2)
    @post.save

  end
end
