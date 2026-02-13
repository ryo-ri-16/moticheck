class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unread_notifications_count, if: :user_signed_in?

  add_flash_types :success, :danger, :first_registration

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  private

  def set_unread_notifications_count
    @unread_notifications_count = current_user.notifications.unread.count
  end
end
