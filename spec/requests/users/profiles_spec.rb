require 'rails_helper'

RSpec.describe "Users::Profiles", type: :request do
  let!(:user) { create(:user) }

  describe "GET /users/profile" do
    context 'ログインしていない場合' do
      it "ログインページにリダイレクトされる" do
        get users_profiles_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログイン済みの場合' do
      it "問題なく動作する" do
        sign_in user
        get users_profiles_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
