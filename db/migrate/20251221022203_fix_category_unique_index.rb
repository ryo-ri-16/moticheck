class FixCategoryUniqueIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :categories, :name
    add_index :categories, [ :user_id, :name ], unique: true
  end
end
