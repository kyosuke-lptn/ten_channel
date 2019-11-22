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
      expect(current_path).to eq profiles_path
    end
  end

  context 'メール送信する場合' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "パスワードを忘れたケース" do
      visit new_user_password_path
      aggregate_failures do
        expect(page).to have_content 'パスワードを再発行します'

        # （失敗）
        click_button '送信'
        expect(page).to have_content 'Eメールを入力してください'

        fill_in 'user_email', with: 'foo@bar.com'
        click_button '送信'
        expect(page).to have_content 'Eメールは見つかりませんでした。'

        # （成功）
        expect {
          fill_in 'user_email', with: user.email
          click_button '送信'
        }.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'

        invalid_url = "http://localhost:3000/users/password/edit?reset_password_token=aa"
        visit invalid_url
        expect(page).to have_content 'パスワード変更'
        fill_in 'user_password', with: 'invalidpass'
        fill_in 'user_password_confirmation', with: 'invalidpass'
        click_button 'パスワードを変更'
        expect(page).to have_content 'パスワードリセット用トークンは不正な値です'

        mail = ActionMailer::Base.deliveries.last
        confirmation_url = extract_confirmation_url(mail)

        visit confirmation_url
        fill_in 'user_password', with: 'validpass'
        fill_in 'user_password_confirmation', with: 'validpass'
        click_button 'パスワードを変更'
        expect(page).to have_content 'パスワードが正しく変更されました。'
        expect(current_path).to eq profiles_path
      end
    end

    def extract_confirmation_url(mail)
      body = mail.body.encoded
      body[/http[^"]+/]
    end
  end
end
