class AddTemplateItemsCountToListTemplates < ActiveRecord::Migration[8.0]
  def change
    add_column :list_templates, :template_items_count, :integer, default: 0, null: false
  end
end
