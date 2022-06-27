# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :assaign_post_and_create_comment, only: %i[index show pending myrejected]
  before_action :find_post, only: %i[show report report_destroy destroy]
  before_action :authenticate_user!

  def index; end

  def show;  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    flash[:notice] = @post.save ? "Post created" : "Error Occured"
    redirect_to posts_path
  end

  def moderator
    @posts = Post.pending_posts
    @comment = Comment.new
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
    @report = Post.create_report(current_user, @post)
    flash[:notice] = @report.save ? "Report Submitted" : "Report Not Submitted"
    redirect_to request.referer
  end

  def report_destroy
    @report = Report.find_by(post_id: @post.id)
    flash[:notice] = @report.destroy ? "Report Withdrawn" : "Report cannot Withdrawn"
    redirect_to request.referer
  end

  def approved
    @approve_post = Post.find params[:id]
    @approve_post.post_status = "approved" if @approve_post.post_status == "pending"
    flash[:notice] =
      @approve_post.save(validate: false) ? "Post has been approved" : "Post is not in pending"
    redirect_to request.referer
  end

  def rejected
    @rejected_post = Post.find params[:id]
    @rejected_post.post_status = "rejected" if @rejected_post.post_status == "pending"
    flash[:notice] =
      @rejected_post.save(validate: false) ? "Post has been rejected" : "Post is not in pending"

    redirect_to request.referer
  end

  def reported
    @reported_posts = Post.reported_posts
  end

  def accept_suggestion
    @find_suggestion = Suggestion.find(params[:format])
    @respective_suggested_post = Post.find(@find_suggestion.post_id)
    @respective_suggested_post.caption = @find_suggestion.suggested_text
    if @respective_suggested_post.save(validate: false)
      Suggestion.delete(@find_suggestion)
      flash[:notice] = "Post caption has been replaced with suggested text"
    end
    redirect_to request.referer
  end

  def reject_suggestion
    @find_suggestion = Suggestion.find(params[:format])
    redirect_to request.referer if Suggestion.delete(@find_suggestion)
  end

  def destroy
    flash[:notice] = @post.destroy ? "Post Destroyed" : "Error Occured While Deleting Post"
    redirect_to request.referer
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image)
  end

  def assaign_post_and_create_comment
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

  def find_post
    @post = Post.find(params[:id])
    authorize @post
  end
end
