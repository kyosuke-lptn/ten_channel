require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:posting_thread) { create(:posting_thread) }
  let!(:comment) { create(:comment, posting_thread_id: posting_thread.id) }

  describe "POST /comment" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        post comments_path, params: {
          comment: {
            content: 'good!!!',
            posting_thread_id: posting_thread.id
          }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST /comment/like" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        post like_comments_path, params: {
          like: {
            good_or_bad: 'good',
            comment_id: comment.id
          }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
