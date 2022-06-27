# frozen_string_literal: true

class Comment < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :post
  belongs_to :user
  belongs_to :commentable, class_name: "Comment", optional: true
  belongs_to :commantable, polymorphic: true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :replies, class_name: "Comment", foreign_key: :commantable_id, dependent: :destroy # rubocop:disable Rails/InverseOf?

  validates :content, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true
end
