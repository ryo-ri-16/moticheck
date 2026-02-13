class AddRemindedAtToLists < ActiveRecord::Migration[8.0]
  def change
    add_column :lists, :reminded_at, :datetime
    add_column :lists, :started_notification_at, :datetime
  end
end
