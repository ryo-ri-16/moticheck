class AddListTemplateToLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :lists, :list_template, null: true, foreign_key: true
  end
end
