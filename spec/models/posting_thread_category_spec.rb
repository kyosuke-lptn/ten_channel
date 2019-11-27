require 'rails_helper'

RSpec.describe PostingThreadCategory, type: :model do
  it { is_expected.to validate_presence_of :posting_thread_id }
  it { is_expected.to validate_presence_of :category_id }
  it { is_expected.to belong_to :posting_thread }
  it { is_expected.to belong_to :category }

  describe "validate uniqueness" do
    let!(:category) { create(:category) }
    let!(:posting_thread) { create(:posting_thread) }

    it "validate uniqueness" do
      test = PostingThreadCategory.new(category_id: category.id, posting_thread_id: posting_thread.id)
      expect(test.valid?).to be_truthy
      test.save
      test1 = PostingThreadCategory.new(category_id: category.id, posting_thread_id: posting_thread.id)
      expect(test1.valid?).to be_falsey
    end
  end
end
