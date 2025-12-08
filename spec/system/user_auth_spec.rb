Capybara.server_host = "localhost"
Capybara.app_host = "http://localhost:3000"

RSpec.describe "User authentication", type: :system do
  before { driven_by(:rack_test) }

  let(:user) { create(:user, password: "password123") }

  describe "ログイン" do
    it "正しくログインできる" do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"

      expect(page).to have_current_path(home_path)
    end
  end

  describe "ログアウト" do
    it "ログアウトできる" do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"

      # ログアウト実行
      click_button "ログアウト"

      expect(page).to have_current_path(root_path)
    end
  end
end
