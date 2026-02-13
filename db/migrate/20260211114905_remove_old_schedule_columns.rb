class RemoveOldScheduleColumns < ActiveRecord::Migration[8.0]
  def change
    remove_column :lists, :scheduled_on, :date
    remove_column :lists, :scheduled_time, :time

    add_index :lists, :scheduled_at
  end
end
