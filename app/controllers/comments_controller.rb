class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    puts @comments
  end

  def show
      @post=Post.find(params[:post_id])
      @comments=@post.find(params[:id])
  end

  def new
    @post=Post.find(params[:post_id])
    @comment=@post.comments.new
  end

  def create  
     @post=current_user.posts.find(params[:post_id])
    # @comment=@post.comments.new(comment_params)
    # @comment.user = current_user
    # @comment.post = @post
    # @comment.save

    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post
    @comment.commantable_type="Post"
    @comment.commantable_id=@post.id
    
    if @comment.save
      redirect_to request.referrer
    end
  end


  def edit
  end

  def update
  end

  def destroy
  end

  def comment_params
    params.require(:comment).permit(:content, :post, :user)
 end
end
