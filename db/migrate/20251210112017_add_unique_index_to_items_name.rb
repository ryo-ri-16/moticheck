class AddUniqueIndexToItemsName < ActiveRecord::Migration[8.0]
  def change
    remove_index :items, :name

    add_index :items, :name, unique: true
  end
end
