FactoryBot.define do
  factory :user, class: User do
    username "Guilherme"
    email  "guilherme@email.com"
    password_digest BCrypt::Password.create('secret', cost: 4)
    role "user"
    trait :other_user do
      username "otherUser"
      email "otheruser@email.com"
    end
  end
end