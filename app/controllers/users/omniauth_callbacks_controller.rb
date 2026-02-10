class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]

    if current_user&.guest?
      convert_guest_to_google(auth)
    else
      handle_google_login(auth)
    end
  end

  def failure
    redirect_to root_path, alert: "Google認証に失敗しました"
  end

  private

  def convert_guest_to_google(auth)
    if current_user.convert_to_google!(auth)
      sign_in(current_user, bypass: true)
      redirect_to root_path,
                  first_registration: "Googleアカウントと連携しました!すべての機能が利用できます"
    else
      redirect_to root_path, alert: "連携に失敗しました: #{current_user.errors.full_messages.join(', ')}"
    end
  end

  def handle_google_login(auth)
    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_path
    end
  end
end
