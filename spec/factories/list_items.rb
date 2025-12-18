FactoryBot.define do
  factory :list_item do
    association :list
    association :item
    quantity { 1 }
    checked { false }
  end
end
