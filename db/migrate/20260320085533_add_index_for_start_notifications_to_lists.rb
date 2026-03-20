class AddIndexForStartNotificationsToLists < ActiveRecord::Migration[8.0]
  def change
    add_index :lists,
            [ :status, :started_notification_at, :scheduled_at ],
            where: "started_notification_at IS NULL",
            name: "index_lists_for_start_notifications"
  end
end
