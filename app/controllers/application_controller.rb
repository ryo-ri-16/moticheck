class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  add_flash_types :success, :danger

  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
