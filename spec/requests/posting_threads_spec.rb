require 'rails_helper'

RSpec.describe "PostingThreads", type: :request do
  let!(:posting_thread) { create(:posting_thread) }
  let!(:category) { create(:category) }

  describe "GET /posting_threads/new" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        get new_posting_thread_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST /posting_threads" do
    context "ログインしていない場合" do
      it "ログインページへリダイレクトされる" do
        post posting_threads_path, params: {
          posting_thread: {
            user_id: posting_thread.user_id,
            title: "変更されたtitle",
            description: "変更されたdescription",
          }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      let!(:category2) { create(:category) }

      it "カテゴリーが追加されている" do
        sign_in posting_thread.user
        post posting_threads_path, params: {
          posting_thread: {
            user_id: posting_thread.user_id,
            title: "変更されたtitle",
            description: "変更されたdescription",
          },
          posting_thread_categories: {
            category_id: ["", category.id]
          }
        }
        saved_thread = PostingThread.find_by(
          user_id: posting_thread.user_id,
          title: "変更されたtitle",
          description: "変更されたdescription",
        )
        expect(saved_thread.categories).to include category
      end

      it "複数のカテゴリーが追加されている" do
        sign_in posting_thread.user
        post posting_threads_path, params: {
          posting_thread: {
            user_id: posting_thread.user_id,
            title: "変更されたtitle",
            description: "変更されたdescription",
          },
          posting_thread_categories: {
            category_id: ["", category.id, category2.id]
          }
        }
        saved_thread = PostingThread.find_by(
          user_id: posting_thread.user_id,
          title: "変更されたtitle",
          description: "変更されたdescription",
        )
        expect(saved_thread.categories).to eq [category, category2]
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
      it "正常に動作している" do
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

    context "ログインしている場合" do
      let!(:posting_thread_with_category) do
        create(:posting_thread, title: "好きな映画", description: "好きな映画について語ろう")
      end
      let!(:movie_category) { create(:category, name: "映画") }

      before do
        PostingThreadCategory.create(
          posting_thread_id: posting_thread_with_category.id,
          category_id: category.id
        )
      end

      it "カテゴリーが変更される" do
        sign_in posting_thread_with_category.user
        patch posting_thread_path(posting_thread_with_category), params: {
          posting_thread: {
            title: build_posting_thread.title,
            description: build_posting_thread.description,
          },
          posting_thread_categories: {
            category_id: ["", category.id]
          }
        }
        posting_thread_with_category.reload
        expect(posting_thread_with_category.title).to eq build_posting_thread.title
        expect(posting_thread_with_category.description).to eq build_posting_thread.description
        expect(posting_thread_with_category.categories).to eq [category]
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
