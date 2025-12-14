class CreateListItems < ActiveRecord::Migration[8.0]
  def change
    create_table :list_items do |t|
      t.references :list, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity
      t.integer :position
      t.boolean :checked, default: false, null: false
      t.string :note

      t.timestamps
    end
    add_index :list_items, [ :list_id, :item_id ], unique: true
  end
end
