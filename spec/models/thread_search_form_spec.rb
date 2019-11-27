require 'rails_helper'

RSpec.describe ThreadSearchForm, type: :model do
  describe '#search' do
    let!(:posting_thread) { create(:posting_thread, title: "あの映画知っている？") }
    let!(:category) { create(:category, name: "映画") }
    let!(:more_comment) { create_list(:comment, 10, posting_thread_id: posting_thread.id) }

    let!(:posting_thread_with_less_comment) { create(:posting_thread, title: "アニメの映画化について語ろう") }
    let!(:other_category) { create(:category, name: "アニメ") }
    let!(:less_comment) { create_list(:comment, 2, posting_thread_id: posting_thread_with_less_comment.id) }

    let!(:posting_thread_without_comment) { create(:posting_thread, title: "おはようー！") }

    before do
      PostingThreadCategory.create(
        posting_thread_id: posting_thread.id,
        category_id: category.id
      )
      PostingThreadCategory.create(
        posting_thread_id: posting_thread_with_less_comment.id,
        category_id: other_category.id
      )
    end

    context 'スレットにコメントがある場合' do
      it "検索ワードとマッチしたスレッドが返ってくる" do
        result = ThreadSearchForm.new(word: "知っている").search
        expect(result).to include posting_thread
        expect(result).not_to include posting_thread_with_less_comment
      end

      it "カテゴリーに指定されたスレッドが帰ってくる" do
        result = ThreadSearchForm.new(categories: [category]).search
        expect(result).to eq [posting_thread]
        expect(result).not_to eq posting_thread_with_less_comment
      end

      it "コメントの多いスレッドが優先して表示される" do
        result = ThreadSearchForm.new(word: "映画").search
        expect(result[0]).to eq posting_thread
        expect(result[1]).to eq posting_thread_with_less_comment
      end

      it "検索に合わなければ空の配列が返る" do
        result = ThreadSearchForm.new(word: "アニメ", categories: [category]).search
        expect(result).to eq []
      end

      it "入力が空であれば空の配列が返る" do
        result = ThreadSearchForm.new(word: "", categories: []).search
        expect(result).to eq []
      end
    end

    # 変更する
    context 'スレットにコメントがない場合' do
      it "コメントがないスレッドは検索対象から除外される" do
        result = ThreadSearchForm.new(word: "おはようー！").search
        expect(result).not_to include posting_thread_without_comment
      end
    end
  end
end
