FactoryBot.define do
  factory :list_template do
    title { "タイトル" }
    association :user
    association :category
    is_initial { false }
  end
end
