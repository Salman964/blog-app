# frozen_string_literal: true

class Like < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :user
  belongs_to :post

  belongs_to :likeable, polymorphic: true

  # validates :user_id, uniqueness: { scope: [:post_id, :comment_id] }
end
