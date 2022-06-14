# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :post, foreign_key: true
      t.references :comment, foreign_key: true
      t.references :reportable, polymorphic: true

      t.timestamps
    end
  end
end
