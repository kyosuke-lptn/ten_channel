FactoryBot.define do
  factory :posting_thread do
    title { 'sample_title' }
    description { 'ここに簡単な説明を書きます' }
    association :user
  end
end
