class Report < ApplicationRecord
  belongs_to :post
  belongs_to :comment
  belongs_to :reportable, polymorphic: true
end
