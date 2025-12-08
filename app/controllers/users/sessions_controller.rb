class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      set_flash_message!(:success, :signed_in)
    end
  end

  # ログアウト時
  def destroy
    super do
      set_flash_message!(:success, :signed_out)
    end
  end
end
