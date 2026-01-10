class BackfillTemplateItemsCount < ActiveRecord::Migration[8.0]
  def up
    add_column :list_templates,
                :list_template_items_count,
                :integer,
                default: 0,
                null: false

    execute <<~SQL
      UPDATE list_templates
      SET list_template_items_count = template_items_count
    SQL

    remove_column :list_templates, :template_items_count
  end

  def down
    add_column :list_templates,
                :template_items_count,
                :integer,
                default: 0,
                null: false

    execute <<~SQL
      UPDATE list_templates
      SET template_items_count = list_template_items_count
    SQL

    remove_column :list_templates, :list_template_items_count
  end
end
