FactoryBot.define do
  factory :user do
    name { "tanaka taro"}


    email { "#{create_email}@example.com" }
    password { "password" }
    confirmed_at { Time.now }
  end
end

def create_email
  array = []
  10.times do
     array << ('a'..'z').to_a[rand(10)]
  end
  array.join
end
