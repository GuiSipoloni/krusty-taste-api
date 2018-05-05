5.times do
  User.create({
    username: Faker::Internet.user_name,
    email: Faker::Internet.email
    })
end

50.times do
  Recipe.create({
    name: Faker::Food.dish,
    description: Faker::Food.description,
    user_id: Faker::Number.between(1, 5)
  })
end

100.times do
Ingredient.create({
  name: Faker::Food.ingredient,
  measurement: Faker::Food.measurement,
  recipe_id: Faker::Number.between(1, 50)
})
end

100.times do
PreparationStep.create({
  step: Faker::Number.between(1, 5),
  description: Faker::Food.description,
  recipe_id: Faker::Number.between(1, 50)
})
end