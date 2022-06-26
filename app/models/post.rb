# frozen_string_literal: true

class Post < ApplicationRecord
  default_scope { order(created_at: :desc) }
  scope :pending_posts, -> { where(post_status: "pending") }
  scope :reported_posts, lambda {
                           where(id: Report.where(reportable_type: "Post").map(&:reportable_id))
                         }

  validates :caption,  presence: true
  validates :user_id,  presence: true

  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :suggestions, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  enum post_status: { pending: 0, approved: 1, rejected: 2 }

  def self.create_report(current_user, post)
    post.reports.new(post_id: post.id, reportable_type: "Post", reportable_id: post.id,
                     user_id: current_user.id)
  end
end
