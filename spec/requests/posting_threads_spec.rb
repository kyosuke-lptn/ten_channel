require 'rails_helper'

RSpec.describe "PostingThreads", type: :request do
  let!(:posting_thread) { create(:posting_thread) }

  describe "GET /posting_threads/new" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        get new_posting_thread_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST /posting_threads" do
    let(:build_posting_thread) { build(:posting_thread) }

    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        post posting_threads_path, params: {
          posting_threads: {
            user_id: build_posting_thread.user_id,
            title: build_posting_thread.title,
            description: build_posting_thread.description,
          }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /posting_thread/:id" do
    context "ログインしていない場合" do
      it "正常に動作している" do
        get posting_thread_path(posting_thread.id)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしている場合" do
      it "@userがnilになる（editへのリンクが表示されない）" do
        sign_in posting_thread.user
        get posting_thread_path(posting_thread.id)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /posting_thread/:id/edit" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        get edit_posting_thread_path posting_thread
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /posting_thread/:id" do
    let(:build_posting_thread) { build(:posting_thread) }

    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        patch posting_thread_path(posting_thread), params: {
          posting_threads: {
            title: build_posting_thread.title,
            description: build_posting_thread.description,
          }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE /posting_thread/:id" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        delete posting_thread_path(posting_thread)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
