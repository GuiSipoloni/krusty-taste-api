FactoryBot.define do
  factory :preparation_step do
    step { Faker::Number.between(1, 10) } 
    description { Faker::Food.description }
    recipe_id { Faker::Number.between(1, 10) } 
  end
end