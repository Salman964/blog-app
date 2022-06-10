class Comment < ApplicationRecord
  default_scope {order(created_at: :desc)}
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :post_id, :presence => true
  

  belongs_to :post
  belongs_to :user
  
  has_many :replies, class_name: "Comment", as: :parent
  belongs_to :commantable, polymorphic: true
end
