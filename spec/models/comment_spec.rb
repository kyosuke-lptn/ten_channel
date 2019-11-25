require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :posting_thread }
  it { is_expected.to have_many :likes }
  it { is_expected.to validate_length_of(:content).is_at_most(200) }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :posting_thread_id }
  it { is_expected.to validate_presence_of :content }

  describe "#good_or_bad?" do
    subject { comment.good_or_bad? user }

    let!(:comment) { create(:comment) }
    let!(:user) { create(:user) }
    let!(:like) { create(:like, user_id: user.id, comment_id: comment.id) }

    it { is_expected.to include "good" }
  end
end
