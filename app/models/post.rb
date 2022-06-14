# frozen_string_literal: true

class Post < ApplicationRecord
  
  default_scope { order(created_at: :desc) }

  # validates :user_id, :presence => true
  validates :caption,  presence: true
  validates :user_id,  presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image, dependent: :destroy

  enum post_status: {pending:0, approved:1, rejected:2}

end
