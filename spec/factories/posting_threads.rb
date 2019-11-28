FactoryBot.define do
  factory :posting_thread do
    title { Faker::Lorem.sentence(word_count: 1) }
    description { Faker::Lorem.sentence(word_count: 3) }
    association :user

    factory :posting_thread_with_category do
      after(:create) do |posting_thread, _|
        category = create(:category)
        PostingThreadCategory.create(
          posting_thread_id: posting_thread.id,
          category_id: category.id
        )
      end
    end
  end
end
