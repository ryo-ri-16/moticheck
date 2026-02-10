require 'rails_helper'

RSpec.describe 'ゲストログイン', type: :system do
  describe 'ゲストログイン機能' do
    it "ゲストユーザーを作成できる" do
      post guest_user_path
      expect(User.last).to be_guest
    end
  end
end
