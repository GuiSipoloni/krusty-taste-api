FactoryBot.define do
  factory :preparation_step, class: PreparationStep do
    step { Faker::Number.between(1, 10) } 
    description { Faker::Food.description }
  end
end