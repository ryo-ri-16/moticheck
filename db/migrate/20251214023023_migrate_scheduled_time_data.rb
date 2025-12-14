class MigrateScheduledTimeData < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE lists
      SET
        scheduled_on   = scheduled_at::date,
        scheduled_time = scheduled_at::time
      WHERE scheduled_at IS NOT NULL;
    SQL
  end

  def down
    execute <<~SQL
      UPDATE lists
      SET
        scheduled_at = TIMESTAMP(scheduled_on, scheduled_time)
      WHERE scheduled_on IS NOT NULL;
    SQL
  end
end
