# frozen_string_literal: true

class AddPostStatusToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :post_status, :integer, default: 0
  end
end
