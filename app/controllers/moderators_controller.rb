class ModeratorsController < ApplicationController
  def index
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def approved
    @approve_post = Post.find params[:id]
    @approve_post.update_attribute(:post_status, 1)
    if @approve_post.save
      render plain: 'Post has been approved'
    end
  end 

  def rejected
    @post = Post.find params[:id]
    @post.update_attribute(:post_status, 2)
    @post.save

  end
end
