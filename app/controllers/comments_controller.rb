# frozen_string_literal: true
class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    puts @comments
  end

  def show
    @post = Post.find(params[:post_id])
    @comments = @post.find(params[:id])
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(commentable_id: params[:comment_id])
  end
  
  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    @comment.commantable_type = 'Post'
    @comment.commantable_id = @post.id
    redirect_to request.referrer if @comment.save  
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to request.referrer
  end

  def comment_params
    params.require(:comment).permit(:content, :post, :user)
  end

  def reply
    @post = Post.find(params[:post_id])
    @parentcomment = @post.comments.find(params[:comment_id])
    @reply = @parentcomment.replies.build
    @reply.user_id = current_user.id
    @reply.post_id = @post.id
    @reply.commantable_type = 'Comment'
    @reply.content=params[:content];
    @reply.commantable_id = @parentcomment.id
    redirect_to request.referrer if @reply.save
  end
end
