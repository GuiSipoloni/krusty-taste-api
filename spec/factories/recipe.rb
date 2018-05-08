FactoryBot.define do
  factory :recipe, class: Recipe do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    public true
    association :user, factory: :user
  end
end