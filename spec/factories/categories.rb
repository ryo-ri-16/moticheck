FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "カテゴリ#{n}" }
    association :user
  end
end
