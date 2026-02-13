FactoryBot.define do
  factory :list do
    association :user
    association :category
    title { "テストリスト" }
    scheduled_at { Time.zone.now }
    status { :waiting }
    note { Faker::Lorem.sentence }
    priority { false }
  end
end
