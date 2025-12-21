require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) { create(:user) }

  describe 'バリデーション' do
    context '成功' do
      it '作成に成功する' do
        category = Category.new(name: '登校', user: user)
        expect(category).to be_valid
      end
    end

    context '失敗' do
      it '名前がないと失敗する' do
        category = Category.new(name: nil, user: user)
        expect(category).not_to be_valid
      end

      it '51文字で失敗' do
        item = build(:category, name: 'a' * 51, user: user)
        expect(item).not_to be_valid
      end

      it '同じ名前のカテゴリは作れない' do
        Category.create!(name: '登校', user: user)
        same_category = Category.new(name: '登校', user: user)
        expect(same_category).not_to be_valid
      end
    end
  end
end
