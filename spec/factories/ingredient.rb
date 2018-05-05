FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }
    measurement { Faker::Food.measurement }
    recipe_id { Faker::Number.between(1, 10) }
  end
end