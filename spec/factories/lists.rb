FactoryBot.define do
  factory :list do
    association :user
    category { user.categories.find_or_create_by!(name: "未分類") }
    title { "テストリスト" }
    scheduled_on { Date.today }
    scheduled_time { '10:00' }
    status { :waiting }
    note { Faker::Lorem.sentence }
    priority { false }
  end
end
