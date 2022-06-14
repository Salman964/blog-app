# frozen_string_literal: true

class AddPolymorphismToComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :comments, :commantable, polymorphic: true
  end
end
