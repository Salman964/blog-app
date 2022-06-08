class CommentsController < ApplicationController
  def index
    @comments = Post.find(params[:post_id]).comments.all
  end

  def show
      @posts=Post.find(params[:post_id])
      @comments=@posts.find(params[:id])
  end

  def new
      @comments =Comment.new(comment_params)
  end

  def create
      @comment=Post.find(params[:id]).comments.new(comment_params)
      # @comments = Comment.new(post_params)
      if @comment.save
          redirect_to @comment
      else
          render :new, status: :unprocessable_entity
      end
  end


  def edit
  end

  def update
  end

  def destroy
  end

  def comment_params
    # params.require(:comment).permit(:text, :username)
 end
end
