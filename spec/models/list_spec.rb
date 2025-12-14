require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    context '成功' do
      it '必須項目があれば成功' do
        list = build(:list, user: user)
        expect(list).to be_valid
      end

      it 'タイトルと利用日以外は任意' do
        list = build(:list, user: user, scheduled_time: nil, note: nil)
        expect(list).to be_valid
      end
    end

    context '失敗' do
      it 'タイトルが空だと失敗' do
        list = build(:list, title: nil, user: user)
        expect(list).to be_invalid
        expect(list.errors[:title]).to be_present
      end

      it '利用日が空だと失敗' do
        list = build(:list, scheduled_on: nil, user: user)
        expect(list).to be_invalid
        expect(list.errors[:scheduled_on]).to be_present
      end

      it 'ユーザーとの関連がなければ失敗' do
        list = build(:list, user: nil)
        expect(list).to be_invalid
      end
    end
  end

  describe 'ステータス管理' do
    context '待機中' do
      let(:list) { create(:list, user: user, status: :waiting) }

      it 'チェック中にできる' do
        expect { list.start_checking! }.to change { list.status }.from('waiting').to('checking')
      end
    end

    context 'チェック中' do
      let(:list) { create(:list, user: user, status: :checking) }

      it 'キャンセルできる' do
        expect { list.back_to_waiting! }.to change { list.status }.from('checking').to('waiting')
      end

      it '完了できる' do
        expect { list.finish_checking! }.to change { list.status }.from('checking').to('completed')
      end
    end
  end

  describe '削除' do
    it '削除できる' do
      list = create(:list, user: user)
      expect { list.destroy }.to change { List.count }.by(-1)
    end
  end
end
