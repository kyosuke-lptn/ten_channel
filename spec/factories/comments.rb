FactoryBot.define do
  factory :comment do
    content { "good!!" }
    association :user
    association :posting_thread
  end
end
