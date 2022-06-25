class RemoveCommentIdFromLikes < ActiveRecord::Migration[5.2]
  def change
    remove_column :likes, :comment_id, :bigint
    remove_column :likes, :post_id, :bigint
  end
end
