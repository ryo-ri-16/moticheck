FactoryBot.define do
  factory :list_template_item do
    name { "MyString" }
    list_template { nil }
    position { 1 }
  end
end
