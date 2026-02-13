class BackfillScheduledAtInLists < ActiveRecord::Migration[8.0]
  def up
    List.reset_column_information

    List.find_each do |list|
      next if list.scheduled_on.blank?

      time_part = list.scheduled_time || Time.parse("00:00")

      combined = Time.zone.local(
        list.scheduled_on.year,
        list.scheduled_on.month,
        list.scheduled_on.day,
        time_part.hour,
        time_part.min,
        time_part.sec
      )

      list.update_column(:scheduled_at, combined)
    end
  end
end
