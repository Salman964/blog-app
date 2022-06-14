class Like < ApplicationRecord
  default_scope {order(created_at: :desc)}

  belongs_to :comment
  belongs_to :likeable, polymorphic: true
end
