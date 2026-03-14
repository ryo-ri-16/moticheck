class CreateNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    return unless user.notifications_enabled?

    create_start_notifications
    create_reminder_notifications if reminder_time?
  end

  private

  # 通知の作成(重複なし)
  def create_start_notifications
    List
      .incomplete.starting_now
      .find_each do |list|
      next if Notification.exists?(user: list.user, list: list, kind: :start)

      begin
        ActiveRecord::Base.transaction do
          Notification.create!(
            user: list.user,
            list: list,
            kind: :start
          )

          list.update!(started_notification_at: Time.current)
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("開始通知の作成に失敗: List ID #{list.id}, #{e.message}")
      end
    end
  end

  # リマインダーの作成
  def create_reminder_notifications
    List
      .incomplete
      .remind_target
      .find_each do |list|
      next if list.reminded_at.present?

      begin
        ActiveRecord::Base.transaction do
          Notification.create!(
            user: list.user,
            list: list,
            kind: :reminder
          )

          list.update!(reminded_at: Time.current)
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("リマインダー通知の作成に失敗: List ID #{list.id}, #{e.message}")
      end
    end
  end

  def reminder_time?
    now.hour == user.notification_hour
  end
end
