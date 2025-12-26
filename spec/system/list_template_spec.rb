require 'rails_helper'

RSpec.describe 'List_templates', type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:list) { create(:list) }

  before do
    login_as(user)
  end

  describe '詳細ページ' do
    let!(:template) { create(:list_template, user: user, title: 'テストテンプレート', category: category) }
    let!(:item1) { create(:list_template_item, list_template: template, name: 'アイテム1', position: 1) }
    let!(:item2) { create(:list_template_item, list_template: template, name: 'アイテム2', position: 2) }

    it 'テンプレートの情報が表示される' do
      visit list_template_path(template)

      expect(page).to have_content('テストテンプレート')
      expect(page).to have_content(category.name)
      expect(page).to have_content('アイテム1')
      expect(page).to have_content('アイテム2')
    end

    it '削除ボタンがある' do
      visit list_template_path(template)

      expect(page).to have_button('削除')
    end
  end

  describe 'リストへコピー' do
    let!(:template) { create(:list_template, user: user, title: 'テンプレート', category: category) }
    let!(:item1) { create(:list_template_item, list_template: template, name: 'アイテム1', position: 1) }
    let!(:item2) { create(:list_template_item, list_template: template, name: 'アイテム2', position: 2) }

    context '成功' do
      it 'テンプレートと同じものがリストにできている' do
        visit list_template_path(template)
        click_button 'リストへコピー'

        copied_list = List.find_by!(user: user, title: 'テンプレート')

        expect(page).to have_current_path(list_path(copied_list))

        expect(page).to have_content('テンプレート')
        expect(page).to have_content(category.name)
        expect(page).to have_content('アイテム1')
        expect(page).to have_content('アイテム2')

        expect(copied_list.title).to eq('テンプレート')
        expect(copied_list.category).to eq(category)
        expect(copied_list.list_items.count).to eq(2)
      end
    end

    context '失敗' do
      it '同じタイトルのものがリストにあるとコピーできない' do
        create(:list, user: user, title: 'テンプレート', category: category)

        visit list_template_path(template)
        click_button 'リストへコピー'

        expect(page).to have_current_path(list_template_path(template))
        expect(page).to have_content('同じタイトルのリスト')
      end
    end
  end

  describe '削除' do
    let!(:user_template) { create(:list_template, user: user, title: 'マイテンプレート') }
    let!(:initial_template) { create(:list_template, is_initial: true, user: nil, title: '初期テンプレート') }

    it 'お気に入りテンプレートは削除できる' do
      visit list_template_path(user_template)

      click_button '削除'

      expect(page).to have_current_path(list_templates_path)
      expect(ListTemplate.exists?(user_template.id)).to be false
    end

    it '初期テンプレートに削除ボタンは表示されない' do
      visit list_template_path(initial_template)

      expect(page).not_to have_button('削除')
    end
  end
end
