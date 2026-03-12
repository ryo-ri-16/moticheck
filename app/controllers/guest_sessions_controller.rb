class GuestSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  # ゲストユーザー作成
  def create
    if session[:guest_user_id]
      user = User.find_by(id: session[:guest_user_id], guest: true)
    end

    unless user
      user = User.create!(
        email: "guest_#{SecureRandom.uuid}@example.com",
        name: "ゲストモード",
        password: SecureRandom.alphanumeric(16),
        guest: true,
        guest_created_at: Time.current
      )
      session[:guest_user_id] = user.id
    end

    sign_in(user, remember_me: true)
    redirect_to root_path, notice: "お試し利用を開始しました"
  end
end
