class AddUniqueIndexToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_index :notifications,
              [ :user_id, :list_id, :kind ],
              unique: true,
              name: "index_notifications_on_user_list_kind_unique"
  end
end
