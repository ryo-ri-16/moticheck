require 'rails_helper'

RSpec.describe ListTemplate, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:list) { create(:list) }

  describe 'バリデーション' do
    it 'タイトルがあれば有効' do
      template = build(:list_template, user: user, title: 'テスト')
      expect(template).to be_valid
    end

    it 'タイトルがなければ無効' do
      template = build(:list_template, user: user, title: nil)
      expect(template).to be_invalid
    end

    it 'タイトルは100文字まで' do
      template = build(:list_template, user: user, title: 'a' * 101)
      expect(template).to be_invalid
    end
  end

  describe 'スコープ' do
    it 'initialはis_initial=trueを拾う' do
      initial = create(:list_template, is_initial: true, title: 'A')
      custom = create(:list_template, is_initial: false, title: 'B')
      expect(ListTemplate.initial).to include(initial)
      expect(ListTemplate.initial).not_to include(custom)
    end

    it 'user_createdはinitialを拾わない' do
      initial = create(:list_template, is_initial: true, title: 'A')
      custom = create(:list_template, is_initial: false, title: 'B')
      expect(ListTemplate.user_created).to include(custom)
      expect(ListTemplate.user_created).not_to include(initial)
    end
  end
end
