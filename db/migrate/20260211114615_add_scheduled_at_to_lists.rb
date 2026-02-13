class AddScheduledAtToLists < ActiveRecord::Migration[8.0]
  def change
    add_column :lists, :scheduled_at, :datetime
  end
end
