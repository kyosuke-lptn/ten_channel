FactoryBot.define do
  factory :posting_thread do
    title { Faker::Lorem.sentence(word_count: 1) }
    description { Faker::Lorem.sentence(word_count: 3) }
    association :user
  end
end
