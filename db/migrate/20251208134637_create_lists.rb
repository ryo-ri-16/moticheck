class CreateLists < ActiveRecord::Migration[8.0]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :status, default: 0, null: false
      t.boolean :priority, default: false, null: false
      t.datetime :scheduled_at
      t.datetime :last_used_at

      t.timestamps
    end

    add_index :lists, [ :user_id, :priority ]
    add_index :lists, :status
    add_index :lists, :last_used_at
  end
end
