class Like < ApplicationRecord
  belongs_to :comment
  belongs_to :likeable, polymorphic: true
end
