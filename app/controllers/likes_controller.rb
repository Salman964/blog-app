# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_post
  before_action :find_like, only: [:destroy]
  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @post.likes.create(user_id: current_user.id, post_id: @post.id, likeable_type: "Post",
                         likeable_id: @post.id)

    end
    redirect_to posts_path(@post)
  end

  def destroy
    if !already_liked?
      flash[:notice] = "Cannot unlike"
    else
      @like.destroy
    end
    redirect_to posts_path(@post)
  end

  def find_like
    @like = @post.likes.find(params[:id])
  end

  def like_on_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
    if @comment.likes.create(post_id: @post.id, user_id: current_user.id, comment_id: @comment.id,
                             likeable_type: "Comment", likeable_id: @comment.id)
      redirect_to posts_path(@post)
    end
  end

  def delete_like_on_comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:comment_id])
    @comment_like = @comment.likes.find_by(user_id: current_user)

    redirect_to posts_path(@post) if @comment_like.delete
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id:
    params[:post_id], likeable_type: "Post").exists?
  end
end
