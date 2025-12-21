FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }

    trait :without_default_category do
      after(:create) do |user|
        user.categories.destroy_all
      end
    end
  end
end
