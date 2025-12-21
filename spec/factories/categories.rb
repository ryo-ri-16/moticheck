FactoryBot.define do
  factory :category do
    association :user
    name { "未分類" }
  end
end
