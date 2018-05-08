FactoryBot.define do
  factory :ingredient, class: Ingredient do
    name { Faker::Food.ingredient }
    measurement { Faker::Food.measurement }
    association :recipe , factory: :recipe
  end
end