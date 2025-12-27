require 'rails_helper'

RSpec.describe 'Home', type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  before do
    login_as(user)
  end

  describe '初回メッセージ' do
    it '初回用メッセージが表示される' do
      visit root_path
      expect(page).to have_content('まだリストがありません')
    end
  end

  describe 'リスト表示ロジック' do
    it '利用日が当日のリストが表示される' do
      create(:list, user:, scheduled_on: Date.current, title: '今日')

      visit root_path

      expect(page).to have_content('今日')
    end

    it '利用日が3日以内のリストが表示される' do
      create(:list, user:, scheduled_on: Date.current + 3, title: '3日')

      visit root_path

      expect(page).to have_content('3日')
    end

    it '4日後以降のリストは表示されない' do
      create(:list, user:, scheduled_on: Date.current + 4, title: '4日')

      visit root_path

      expect(page).not_to have_content('4日')
    end

    it '利用日が過ぎていてかつ完了していないリストが表示される' do
      create(:list, user:, scheduled_on: Date.current - 1, title: '昨日')

      visit root_path

      expect(page).to have_content('昨日')
    end

    it '利用日が過ぎていてかつ完了済みのリストはホームで表示されない' do
      create(:list, user:, scheduled_on: Date.current - 1, status: :completed, title: '完了済み')

      visit root_path

      expect(page).not_to have_content('完了済み')
    end

    it 'FABを押せば新規作成ページに遷移' do
      visit root_path
      click_on '＋'
      expect(page).to have_current_path(new_list_path)
    end
  end
end
