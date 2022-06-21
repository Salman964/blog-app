# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :find_post
  
  def index
    @comments = Comment.all
  end
  def show
    @comments = @post.comments.find(params[:id])
    @user = @comments.user
  end

  def new
    @comment = @post.comments.new(commentable_id: params[:comment_id])
  end
  
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    @comment.commantable_type = 'Post'
    @comment.commantable_id = @post.id
    redirect_to request.referrer if @comment.save  
  end

  def destroy   
    @comment = @post.comments.find(params[:id])
    if @comment.destroy  
       redirect_to posts_path
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :post, :user)
  end

  def reply
    @parentcomment = @post.comments.find(params[:id])
    @reply = @parentcomment.replies.build
    @reply.user_id = current_user.id
    @reply.post_id = @post.id
    @reply.commantable_type = 'Comment'
    @reply.content=params[:content];
    @reply.commantable_id = @parentcomment.id
    redirect_to request.referrer if @reply.save
  end


  def like
    @comment = @post.comments.find(params[:id])
    if @comment.likes.create(post_id: @post.id, user_id: current_user.id,comment_id: @comment.id ,likeable_type: 'Comment', likeable_id: @comment.id )
      redirect_to request.referrer
    end
  end
  
  def like_destroy
    @comment = @post.comments.find(params[:id])
    @comment_like = @comment.likes.find_by(user_id: current_user)
  
    if @comment_like.delete
      redirect_to request.referrer
    end
  end
  
  def report
  end
  
  private
    def find_post
      @post = Post.find(params[:post_id])
    end
end


