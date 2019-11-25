require 'rails_helper'

RSpec.describe PostingThread, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_length_of(:title).is_at_most(100) }
  it { is_expected.to validate_length_of(:description).is_at_most(500) }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :posting_thread_categories }

  describe "#categories" do
    let!(:category) { create(:category) }
    let!(:posting_thread) { create(:posting_thread) }

    it "#categories" do
      test = PostingThreadCategory.create(category_id: category.id, posting_thread_id: posting_thread.id)
      expect(test.category).to eq posting_thread.categories.first
    end
    it "#posting_threads" do
      test = PostingThreadCategory.create(category_id: category.id, posting_thread_id: posting_thread.id)
      expect(test.posting_thread).to eq category.posting_threads.first
    end
  end
end
