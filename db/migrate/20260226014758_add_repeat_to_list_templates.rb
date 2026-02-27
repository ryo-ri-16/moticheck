class AddRepeatToListTemplates < ActiveRecord::Migration[8.0]
  def change
    add_column :list_templates, :repeat_type, :integer, default: 0, null: false
    add_column :list_templates, :repeat_days, :integer, default: 0, null: false
  end
end
