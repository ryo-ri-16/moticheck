FactoryBot.define do
  factory :notification do
    association :user
    association :list
    kind { :reminder }
    read_at { nil }

    trait :read do
      read_at { 1.day.ago }
    end

    trait :start_kind do
      kind { :start }
    end
  end
end
