require 'rails_helper'

RSpec.describe Like, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :comment }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :comment_id }
  # it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:comment_id) }

  describe "good_or_bad" do
    let(:like) { create(:like) }
    let(:bad_like) { create(:like, :bad) }

    it "good_or_bad" do
      expect(like.valid?).to be_truthy
      expect(bad_like.valid?).to be_truthy
      like.good_or_bad = "awesome"
      expect(like.valid?).to be_falsey
      like.good_or_bad = ""
      expect(like.valid?).to be_truthy
    end
  end
end
