# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :assaign_post_and_create_comment
  before_action :find_post, only: %i[show report report_destroy like like_destroy]
  
  def index; end

  def show;  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to posts_path
    else
      render status: :not_found
    end
  end

  def pending; end

  def myrejected; end

  def report
    @report = Report.new
    @report = @post.reports.new(post_id: @post.id, reportable_type: "Post", reportable_id: @post.id,
                                user_id: current_user.id)
    redirect_to request.referer if @report.save
  end

  def report_destroy
    @report = Report.find_by(post_id: @post.id)
    redirect_to request.referer if @report.destroy
  end

  def like
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @like = @post.likes.new(user_id: current_user.id, post_id: @post.id, likeable_type: "Post",
                              likeable_id: @post.id)
    end

    respond_to do |format|
      if @like.save
        format.html { redirect_to request.referer }
        # format.json { head :no_content }
        format.js
      end
    end
    # redirect_to request.referer if @like.save
  end

  def like_destroy
    @like = Like.find_by(post_id: @post.id)
    redirect_to request.referer if @like.destroy
  end

  def approved
    @approve_post = Post.find params[:id]
    @approve_post.update_attribute(:post_status, 1)
    render plain: "Post has been approved" if @approve_post.save
  end

  def rejected
    @rejected_post = Post.find params[:id]
    @rejected_post.update_attribute(:post_status, 2)
    render plain: "Post has been rejected" if @rejected_post.save
  end

  def reported
    @reported_posts = Post.where(id: Report.where(reportable_type: "Post").map(&:reportable_id))
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image)
  end

  def report_params
    params.require(:report).permit.per
  end

  def assaign_post_and_create_comment
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def find_post
    @post = Post.find(params[:id])
    authorize @post
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id:
    params[:post_id], likeable_type: "Post").exists?
  end
end
