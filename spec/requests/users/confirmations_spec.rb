require 'rails_helper'

RSpec.describe "Users::Confirmations", type: :request do
  describe "GET /users/new" do
    it "問題なく動作する" do
      get new_user_confirmation_path
      expect(response).to have_http_status(200)
    end
  end
end
