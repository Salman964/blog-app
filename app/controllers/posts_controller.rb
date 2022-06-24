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
      flash[:notice] = "Post created"
      redirect_to posts_path
    else
      flash[:notice] = "Error Occured"
      render status: :not_found
    end
  end

  def suggestions
    @suggestion = Suggestion.new(post_id: params[:id], user_id: current_user.id,
                                 suggested_text: params[:suggested_text])
    if @suggestion.save
      flash[:notice] = "Successfully submitted"
      redirect_to request.referer
    else
      flash[:notice] = "Not Submitted"

    end
  end

  def suggestions_index
    @suggestions = Suggestion.all
  end

  def pending; end

  def myrejected; end

  def report
    @report = Report.new
    @report = @post.reports.new(post_id: @post.id, reportable_type: "Post", reportable_id: @post.id,
                                user_id: current_user.id)

    if @report.save
      flash[:notice] = "Report Submitted"
      redirect_to request.referer
    else
      flash[:notice] = "Report Not Submitted"
    end
  end

  def report_destroy
    @report = Report.find_by(post_id: @post.id)
    if @report.destroy
      flash[:notice] = "Report Withdrawn"
      redirect_to request.referer
    else
      flash[:notice] = "Report cannot Withdrawn"
    end
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
        format.js
      end
    end
  end

  def like_destroy
    @like = Like.find_by(post_id: @post.id)
    redirect_to request.referer if @like.destroy
  end

  def approved
    if current_user
      @approve_post = Post.find params[:id]
      if @approve_post.post_status == "pending"
        @approve_post.post_status = "approved"
        render plain: "Post has been approved" if @approve_post.save(validate: false)
      else
        render plain: "Post is not pending"
      end
    else
      render plain: "Sign in first"

    end
  end

  def rejected
    @rejected_post = Post.find params[:id]
    if @rejected_post.post_status == "pending"
      @rejected_post.post_status = "approved"
      render plain: "Post has been approved" if @rejected_post.save(validate: false)
    else
      render plain: "Post already approved idiot"
    end
  end

  def reported
    @reported_posts = Post.where(id: Report.where(reportable_type: "Post").map(&:reportable_id))
  end

  def accept_suggestion
    @find_suggestion = Suggestion.find(params[:format])
    @respective_suggested_post = Post.find(@find_suggestion.post_id)
    @respective_suggested_post.caption = @find_suggestion.suggested_text
    if @respective_suggested_post.save(validate: false)
      render plain: "Post caption has been replaced with suggested text"
    end
    Suggestion.delete(@find_suggestion)
  end

  def reject_suggestion
    @find_suggestion = Suggestion.find(params[:format])
    redirect_to request.referer if Suggestion.delete(@find_suggestion)
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
