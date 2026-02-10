class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if current_user&.guest?
      convert_guest
    else
      super
    end
  end

  private

  def convert_guest
    current_user.convert_to_registration!(
      email: sign_up_params[:email],
      password: sign_up_params[:password],
      password_confirmation: sign_up_params[:password_confirmation]
    )

    sign_in(current_user)
    redirect_to root_path, notice: "ユーザー登録が完了しました"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "登録に失敗しました"
    render :new
  end
end
