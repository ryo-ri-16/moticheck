class AddScheduledColumnsToLists < ActiveRecord::Migration[8.0]
  def change
    add_column :lists, :scheduled_on, :date
    add_column :lists, :scheduled_time, :time
  end
end
