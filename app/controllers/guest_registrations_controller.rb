class GuestRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest

  def new
  end

  # ゲストから本登録へ
  def create
    if current_user.convert_to_registration!(
          name: params[:user][:name],
          email: params[:user][:email],
          password: params[:user][:password],
          password_confirmation: params[:user][:password_confirmation]
      )

      bypass_sign_in(current_user)

      redirect_to root_path, first_registration: "本登録が完了しました！すべての機能が利用できます"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ensure_guest
    redirect_to root_path unless current_user.guest?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
