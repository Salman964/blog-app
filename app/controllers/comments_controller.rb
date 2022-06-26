# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :find_post
  before_action :parentcomment, only: %i[reply]

  def index
    @comments = Comment.all
  end

  def new
    @comment = @post.comments.new(commentable_id: params[:comment_id])
  end

  def create
    @comment = Comment.new(user: current_user, post: @post, commantable_type: "Post",
                           commantable_id: @post.id, content: params[:comment][:content])

    redirect_to posts_path if @comment.save
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    redirect_to posts_path if @comment.destroy
  end

  def comment_params
    params.require(:comment).permit(:content, :post, :user)
  end

  def reply
    @reply = @parentcomment.replies.build(commantable_type: "Comment", content: params[:content],
                                          commantable_id: @parentcomment.id)
    @reply.post_id = @post.id
    @reply.user_id = current_user.id
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

  def edit
    @comment = @post.comments.find(params[:id])
  end

  def update
    @comment = @post.comments.find(params[:id])

    if @comment.update
      redirect_to posts_path
    else
      render "edit"
    end
  end

  private

  def parentcomment
    @parentcomment = @post.comments.find(params[:id])
  end

  def find_post
    @post = Post.find(params[:post_id])
  end
end
