require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'バリデーション' do
    context '成功' do
      it '保存できる' do
        item = build(:item)
        expect(item).to be_valid
      end

      it '100文字で保存' do
        item = build(:item, name: 'a' * 100)
        expect(item).to be_valid
      end

      it '前後の空白を除去する' do
        item = create(:item, name: '  りんご  ')
        expect(item.name).to eq 'りんご'
      end
    end

    context '失敗' do
      it '空白で失敗' do
        item = build(:item, name: '')
        expect(item).to be_invalid
      end

      it 'nilで失敗' do
        item = build(:item, name: nil)
        expect(item).to be_invalid
      end

      it '101文字で失敗' do
        item = build(:item, name: 'a' * 101)
        expect(item).to be_invalid
      end

      it '重複で失敗' do
        create(:item, name: 'りんご')
        same_name = build(:item, name: 'りんご')
        expect(same_name).to be_invalid
      end
    end
  end
end
