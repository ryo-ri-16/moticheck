class Users::NotificationSettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(notification_params)
      redirect_to edit_notification_setting_path,
                  notice: "通知設定を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:user).permit(
      :notifications_enabled,
      :reminder_enabled,
      :reminder_days_before,
      :notification_hour
    )
  end
end
