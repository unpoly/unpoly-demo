class AddTagsToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :tags, :string, array: true, default: []
  end
end
