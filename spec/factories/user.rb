FactoryBot.define do
  factory :user do
    username "Guilherme"
    email  "test@email.com"
    password_digest BCrypt::Password.create('secret', cost: 4)
    role "user"
  end

  factory :user_seed, class: User do 
    username { Faker::Internet.user_name } 
    email { Faker::Internet.email }
    password_digest BCrypt::Password.create('secret', cost: 4)
  end
end