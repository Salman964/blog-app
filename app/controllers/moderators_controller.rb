class ModeratorsController < ApplicationController
  def index
    @posts = Post.includes(:user).order(updated_at: :desc)
    @comment = Comment.new
  end

end