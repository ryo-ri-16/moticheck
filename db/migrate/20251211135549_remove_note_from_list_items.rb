class RemoveNoteFromListItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :list_items, :note, :string
  end
end
