require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let!(:user) { create(:user) }

  describe "GET /users/sign_up" do
    it "問題なく動作する" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end

    context 'ログイン済みの場合' do
      it "ユーザー詳細画面にリダイレクトされる" do
        sign_in user
        get new_user_registration_path
        expect(response).to redirect_to users_profiles_path
      end
    end
  end
end
