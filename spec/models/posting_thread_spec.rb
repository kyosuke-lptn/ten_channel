require 'rails_helper'

RSpec.describe PostingThread, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_length_of(:title).is_at_most(100) }
  it { is_expected.to validate_length_of(:description).is_at_most(500) }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :posting_thread_categories }

  describe "#filter_by_categories" do
    let!(:posting_thread) { create(:posting_thread) }
    let!(:posting_thread_with_category) { create(:posting_thread) }
    let!(:category) { create(:category, name: "映画") }

    before do
      PostingThreadCategory.create(
        posting_thread_id: posting_thread_with_category.id,
        category_id: category.id
      )
    end

    it "カテゴリーが含まれる物のみ出力" do
      result = PostingThread.filter_by_categories(["映画"])
      expect(result).to eq [posting_thread_with_category]
    end
  end

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
