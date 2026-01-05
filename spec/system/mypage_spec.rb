require 'rails_helper'

RSpec.describe 'Mypage', type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe 'カテゴリ管理' do
    it 'カテゴリ一覧が表示される' do
      create(:category, user: user, name: '仕事')
      visit categories_path
      expect(page).to have_content('仕事')
    end

    it 'カテゴリを削除できる' do
      category = create(:category, user: user)
      visit categories_path
      click_button '削除'
      expect(page).not_to have_content(category.name)
    end

    it '未分類が表示されない' do
      visit categories_path
      expect(page).not_to have_content('未分類')
    end
  end
end
