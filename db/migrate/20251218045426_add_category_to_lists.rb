class AddCategoryToLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :lists, :category, foreign_key: true, null: true
  end
end
