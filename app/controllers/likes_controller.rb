# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @like = Like.new(likeable_id: params[:likeable_id], likeable_type: params[:likeable_type],
                     user_id: current_user.id)
    flash[:notice] = if @like.save
                       "save like"
                     else
                       @like.errors.full_messages
                     end
    redirect_to request.referer
  end

  def destroy
    @find_like = Like.find_by(likeable_id: params[:likeable_id],
                              likeable_type: params[:likeable_type], user_id: current_user.id)

    flash[:notice] = if @find_like.destroy
                       "Unlike successfully "
                     else
                       "Error while Unlike "
                     end
    redirect_to request.referer
  end
end
