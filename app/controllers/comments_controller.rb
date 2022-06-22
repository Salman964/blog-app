# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :find_post

  def index
    @comments = Comment.all
  end

  # def show
  #   @comments = @post.comments.find(params[:id])
  #   @user = @comments.user
  # end

  def new
    @comment = @post.comments.new(commentable_id: params[:comment_id])
  end

  def create
    @comment = Comment.new(user: current_user, post: @post, commantable_type: "Post",
                           commantable_id: @post.id, content: params[:comment][:content])
    redirect_to request.referer if @comment.save
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    redirect_to posts_path if @comment.destroy
  end

  def comment_params
    params.require(:comment).permit(:content, :post, :user)
  end

  def reply
    @parentcomment = @post.comments.find(params[:id])
    @reply = @parentcomment.replies.build
    @reply = @parentcomment.replies.build(user_id: current_user.id, post_id: @post.id,
                                          commantable_type: "Comment", content: params[:content], commantable_id: @parentcomment.id)
    redirect_to request.referer if @reply.save
  end

  def like
    @comment = @post.comments.find(params[:id])
    if @comment.likes.create(post_id: @post.id, user_id: current_user.id, comment_id: @comment.id,
                             likeable_type: "Comment", likeable_id: @comment.id)
      redirect_to request.referer
    end
  end

  def like_destroy
    @comment = @post.comments.find(params[:id])
    @comment_like = @comment.likes.find_by(user_id: current_user)

    redirect_to request.referer if @comment_like.delete
  end

  def report
    @comment = @post.comments.find(params[:id])
    if @comment.reports.create(post_id: @post.id, user_id: current_user.id, comment_id: @comment.id,
                               reportable_type: "Comment", reportable_id: @comment.id)
      redirect_to request.referer
    end
  end

  def report_destroy
    @comment = @post.comments.find(params[:id])
    @comment_report = @comment.reports.find_by(user_id: current_user)
    redirect_to request.referer if @comment_report.delete
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end
