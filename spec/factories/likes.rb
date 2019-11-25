FactoryBot.define do
  factory :like do
    association :user
    association :comment
    good_or_bad { "good" }

    trait :bad do
      good_or_bad { "bad" }
    end
  end
end
