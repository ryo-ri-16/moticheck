require 'rails_helper'

RSpec.describe ListItem, type: :model do
  let(:list) { create(:list) }
  let(:item) { create(:item) }

  describe 'バリデーション' do
    context '成功' do
      it '保存できる' do
        li = build(:list_item, list: list, item: item, quantity: 1)
        expect(li).to be_valid
      end

      it '数量999で保存できる' do
        li = build(:list_item, list: list, item: item, quantity: 999)
        expect(li).to be_valid
      end
    end

    context '失敗' do
      it '数量0で失敗' do
        li = build(:list_item, list: list, item: item, quantity: 0)
        expect(li).to be_invalid
      end

      it '数量が負の値で失敗' do
        li = build(:list_item, list: list, item: item, quantity: -1)
        expect(li).to be_invalid
      end

      it '同じリストに同じアイテムは複数存在しない' do
        create(:list_item, list: list, item: item)
        li = build(:list_item, list: list, item: item)
        expect(li).to be_invalid
      end
    end

    context 'デフォルト値' do
      it 'checkedのデフォルトはfalse' do
        li = create(:list_item, list: list, item: item)
        expect(li.checked).to eq(false)
      end

      it 'positionが割り振られている' do
        li1 = create(:list_item, list: list)
        li2 = create(:list_item, list: list)
        expect(li2.position).to eq(li1.position + 1)
      end
    end
  end
end
