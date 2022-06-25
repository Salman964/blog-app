# frozen_string_literal: true

class Like < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
