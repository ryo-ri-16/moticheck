class AddDescriptionToListTemplates < ActiveRecord::Migration[8.0]
  def change
    add_column :list_templates, :description, :text
    add_column :list_templates, :is_initial, :boolean, default: false, null: false

    add_index :list_templates, [ :user_id, :title ]
    add_index :list_templates, :is_initial
  end
end
