class AddNotNullToScheduledAt < ActiveRecord::Migration[8.0]
  def change
    change_column_null :lists, :scheduled_at, false
  end
end
