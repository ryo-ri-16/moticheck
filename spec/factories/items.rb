FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "アイテム#{n}" }

    trait :key do
      name { "鍵" }
    end

    trait :wallet do
      name { "財布" }
    end

    trait :umbrella do
      name { "傘" }
    end
  end
end
