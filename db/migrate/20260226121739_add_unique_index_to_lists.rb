class AddUniqueIndexToLists < ActiveRecord::Migration[8.0]
  def change
    add_index :lists,
              [ :list_template_id, :target_date ],
              unique: true,
              where: "list_template_id IS NOT NULL",
              name: "index_lists_on_template_and_date_unique"
  end
end
