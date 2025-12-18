require 'rails_helper'

RSpec.describe 'Lists', type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
  end

  describe 'リスト作成' do
    context '成功' do
      it '一覧に表示される' do
        visit new_list_path

        fill_in 'タイトル', with: '旅行の持ち物'
        fill_in '利用日', with: Date.today
        click_button '作成する'

        expect(page).to have_content('旅行の持ち物')
      end

      it 'ステータスが表示される' do
        list = create(:list, user: user, status: :waiting)

        visit lists_path

        expect(page).to have_content('待機中')
      end
    end

    context '失敗' do
      it 'タイトルなし' do
        visit new_list_path

        fill_in '利用日', with: Date.today
        expect { click_button '作成する' }.not_to change { List.count }
      end

      it '利用日なし' do
        visit new_list_path

        fill_in 'タイトル', with: '旅行の持ち物'
        expect { click_button '作成する' }.not_to change { List.count }
      end
    end
  end

  describe 'ステータス遷移' do
    context '待機中' do
      it 'チェック開始できる' do
        list = create(:list, user: user, status: :waiting)

        visit list_path(list)
        click_button 'チェック開始'

        expect(page).to have_content('チェック中')
      end
    end

    context 'チェック中' do
      it 'キャンセルできる' do
        list = create(:list, user: user, status: :checking)

        visit list_path(list)
        click_button 'チェックキャンセル'

        expect(page).to have_content('待機中')
      end

      it '完了できる' do
        list = create(:list, user: user, status: :checking)

        visit list_path(list)
        click_button 'チェック完了'

        expect(page).to have_content('完了')
      end
    end
  end

  describe '複製' do
    it '複製できる' do
      list = create(:list, user: user)

      visit list_path(list)
      expect { click_button '複製' }.to change { List.count }.by(1)
    end
  end

  describe '削除' do
    it '削除できる' do
      list = create(:list, user: user)

      visit list_path(list)
      click_button '削除'

      expect(page).not_to have_content(list.title)
    end
  end

  describe 'アイテム操作' do
    context '待機中' do
      it 'アイテムを追加できる' do
        list = create(:list, user: user)

        visit list_path(list)
        fill_in 'アイテム名', with: '鍵'

        expect { click_button '追加' }.to change { ListItem.count }.by(1)
      end

      it '数量付きで追加できる' do
        list = create(:list, user: user)

        visit list_path(list)
        fill_in 'アイテム名', with: '鍵'
        fill_in '数量:', with: 3

        expect { click_button '追加' }.to change { ListItem.count }.by(1)

        list_item = list.list_items.order(:created_at).last
        expect(list_item.quantity).to eq(3)
      end

      it 'アイテムを削除できる' do
        list = create(:list, user: user)
        item = create(:item, name: 'りんご')
        li = create(:list_item, list: list, item: item)

        visit list_path(list)

        within "tr#list_item_row_#{li.id}" do
          find('summary').click
          click_button '削除'
        end

        expect(ListItem.exists?(li.id)).to be false
      end
    end
  end
end
