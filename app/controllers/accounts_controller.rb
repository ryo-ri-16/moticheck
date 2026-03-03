class AccountsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "アカウントを削除しました。"
  end
end
