class PostsController < ApplicationController
  def index
      #  @posts = current_user.posts.all      
      @posts = Post.includes(:user).order(updated_at: :desc)
      @comment =Comment.new

      # @post=Post.find(params[:post_id])
      # @comment=@post.comments.new
  end
  
  def show
      @post=current_user.posts.find(params[:id])
  end

  def new 
      @post =current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.user=current_user
    if @post.save
      flash[:notice] = "Post Created....."
      # redirect_to feed_users_path
    else
      render :new
    end
  end


  def edit
  end

  def update
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:caption,:image)
  end

end
