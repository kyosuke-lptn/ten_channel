FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence(word_count: 2) }
    association :user
    association :posting_thread
  end
end
