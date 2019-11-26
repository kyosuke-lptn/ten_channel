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

  describe "#text_match" do
    let!(:name_posting_thread) { create(:posting_thread, title: "match-text") }
    let!(:name_comments10) { create_list(:comment, 3, posting_thread_id: name_posting_thread.id) }
    let!(:description_posting_thread) { create(:posting_thread, description: "aaaaa match-text aaaa") }
    let!(:description_comments5) { create_list(:comment, 2, posting_thread_id: description_posting_thread.id) }
    let!(:comment_posting_thread) { create(:posting_thread) }
    let!(:comment_comments1) { create(:comment, content: "match-text", posting_thread_id: comment_posting_thread.id) }
    let!(:no_match_posting_thread) { create(:posting_thread, title: "no!!!", description: "no!!!") }
    let!(:no_matoch_comments) { create_list(:comment, 4, content: "no!!!!!!", posting_thread_id: no_match_posting_thread.id) }
    let!(:threads) { PostingThread.text_match("match-text") }

    it "コメント数の多いthreadが一番に取得できる" do
      expect(threads[0]).to eq name_posting_thread
    end

    it "コメント数の少ないthreadが最後に取得できる" do
      expect(threads[-1]).to eq comment_posting_thread
    end

    it "検索したワードを含まない物は入っていない" do
      expect(threads).not_to include [no_match_posting_thread]
    end
  end


end
