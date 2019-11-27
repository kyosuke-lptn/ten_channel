FactoryBot.define do
  factory :category do
    name { Faker::Artist.name }
  end
end
