class AddNotificationsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :notifications_enabled, :boolean, default: true, null: false
    add_column :users, :reminder_enabled, :boolean, default: true, null: false
    add_column :users, :reminder_days_before, :integer, default: 1
    add_column :users, :notification_hour, :integer, default: 20
  end
end
