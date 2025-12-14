class RemoveOldScheduledTimeFromLists < ActiveRecord::Migration[8.0]
  def change
    remove_column :lists, :scheduled_at, :datetime
  end
end
