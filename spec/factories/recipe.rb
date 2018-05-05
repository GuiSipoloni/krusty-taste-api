FactoryBot.define do
  factory :recipe do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    user_id 2
  end
end