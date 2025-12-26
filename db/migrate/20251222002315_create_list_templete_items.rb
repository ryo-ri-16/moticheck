class CreateListTempleteItems < ActiveRecord::Migration[8.0]
  def change
    create_table :list_template_items do |t|
      t.string :name
      t.references :list_template, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
