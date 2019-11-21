require 'rails_helper'

RSpec.describe "SignInAndOuts", type: :system do
  let!(:user) { create(:user) }

  it "ログインからログアウトまでの流れ" do
    visit new_user_session_path
    aggregate_failures do
      expect(page).to have_content 'ログイン'

      click_button 'ログイン'
      expect(page).to have_content 'Eメールまたはパスワードが違います。'

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'ログイン'
      expect(page).not_to have_content 'Eメールまたはパスワードが違います。'
      expect(current_path).to eq user_path(user)
    end
  end
end
