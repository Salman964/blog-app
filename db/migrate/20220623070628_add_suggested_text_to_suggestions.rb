class AddSuggestedTextToSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :suggestions, :suggested_text, :text
  end
end
