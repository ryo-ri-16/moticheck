class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true
      t.integer :kind, null: false
      t.datetime :read_at

      t.timestamps
    end
    add_index :notifications, [ :user_id, :read_at ]
    add_index :notifications, :kind
  end
end
