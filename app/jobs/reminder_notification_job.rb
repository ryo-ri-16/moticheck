class ReminderNotificationJob < ApplicationJob
  def perform
    User.where(
      notifications_enabled: true,
      reminder_enabled: true
    ).find_each do |user|
      next unless Time.current.hour == user.notification_hour

      user.lists.incomplete.remind_target.find_each do |list|
        next if list.reminded_at.present?

        Notification.create!(
          user: user,
          list: list,
          kind: :reminder
        )

        list.update!(reminded_at: Time.current)
      end
    end
  end
end
