class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :parent dependent: :destroy
end
