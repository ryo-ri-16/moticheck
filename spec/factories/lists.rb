FactoryBot.define do
  factory :list do
    association :user
    title { "テストリスト" }
    scheduled_on { Date.today }
    scheduled_time { '10:00' }
    status { :waiting }
    note { Faker::Lorem.sentence }
    priority { false }
  end
end
