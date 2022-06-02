class Comment < ApplicationRecord
  belongs_to :post
  has_many :replies, class_name: "Comment", as: :parent
  belongs_to :parent, polymorphic: true
end
