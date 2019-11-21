FactoryBot.define do
  factory :user do
    name { "tanaka taro"}
    email { "tanaka@example.com" }
    password { "password" }
    confirmed_at { Time.now }
  end
end
