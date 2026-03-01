class CreateStartNotificationJob < ApplicationJob
  def perform
    List.incomplete.starting_now.find_each do |list|
      next unless list.user.notifications_enabled?

      Notification.create!(
        user: list.user,
        list: list,
        kind: :start
      )
      list.update!(started_notification_at: Time.current)
    end
  end
end
