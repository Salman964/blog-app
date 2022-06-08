class Comment < ApplicationRecord
  default_scope {order(created_at: :desc)}

  
  belongs_to :post
  has_many :replies, class_name: "Comment", as: :parent
  belongs_to :parent, polymorphic: true
end
