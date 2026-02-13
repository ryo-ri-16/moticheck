class NotificationsController < ApplicationController
  before_action :set_notification, only: [ :update, :destroy ]

  def index
    @unread_notifications = current_user.notifications
                                        .unread.recent
                                        .includes(:list)
    @read_notifications   = current_user.notifications
                                        .read.recent
                                        .includes(:list).limit(20)
  end

  def update
    @notification.mark_as_read!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path, notice: "通知を確認しました" }
    end
  end

  # 全て既読
  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)

    redirect_to notifications_path, notice: "全ての通知を既読にしました"
  end

  def destroy
    @notification.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path, notice: "通知を削除しました" }
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
