# frozen_string_literal: true

class PostsController < ApplicationController  
  before_action :assaign_post_and_create_comment
  # before_action :find_post_comment
  # before_action :find_like, only: [:destroy]
  
  def index
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to posts_path
      # redirect_to "http://localhost:3000/posts"
    else
      render :status => 404
    end
  end

  def pending; end

  def myrejected; end

  def report
    @post = Post.find(params[:id])
    @report=Report.new(report_params)
    @report.post_id=@post_id
    @report.reportable_type="Post" 
    @report.reportable_id=@post.id 
    @report.user_id:current_user.id
    
    # @report=Report.new(post_id:@post.id, reportable_type:"Post", reportable_id:@post.id, user_id:current_user.id)
    if @report.save
      byebug
      redirect_to request.referrer
    end
  end

  def like
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @post = Post.find(params[:id])
      @post.likes.create(user_id: current_user.id,post_id: @post.id ,likeable_type: 'Post', likeable_id: @post.id )
    end
    redirect_to request.referrer
  end

  def like_destroy
    @post = Post.find(params[:id])
    @like = Like.find_by(post_id: @post.id)
    if @like.destroy
    redirect_to request.referrer
    end
  end


  def approved
    @approve_post = Post.find params[:id]
    @approve_post.update_attribute(:post_status, 1)
    if @approve_post.save
      render plain: 'Post has been approved'
    end
  end 

  def rejected
    @rejected_post = Post.find params[:id]
    @rejected_post.update_attribute(:post_status, 2)
    if @rejected_post.save
      render plain: 'Post has been rejected'
    end
  end

  private
  def post_params
    params.require(:post).permit(:caption, :image)
  end

  def report_params
    params.require(:report).permit.permit!
  end

  def assaign_post_and_create_comment
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end


  def find_post_comment
    @post = Post.find(params[:post_id])
    if params[:comment_id]
       @comment = @post.comments.find(params[:comment_id])
    end
  end

  def already_liked?
    Like.where(user_id: current_user.id, post_id:
    params[:post_id], likeable_type: "Post").exists?
  end

end
