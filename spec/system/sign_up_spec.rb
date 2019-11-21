require 'rails_helper'

RSpec.describe "SignInAndOuts", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  it "ユーザー登録" do
    visit new_user_registration_path
    aggregate_failures do
      expect(page).to have_content 'ログイン'

      click_button 'アカウント登録'
      expect(page).to have_content 'アカウント登録'

      # 入力しなかった場合（登録失敗）
      expect {
        click_button 'アカウント登録'
      }.to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(page).to have_content '3 件のエラーが発生したため ユーザー は保存されませんでした。'

      # 入力が正しくない場合（登録失敗）
      expect {
        fill_in 'user_name', with: 'sample'
        fill_in 'user_email', with: 'sample@a'
        fill_in 'user_password', with: 'pa'
        fill_in 'user_password_confirmation', with: 'pp'
      }.to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(page).to have_content '3 件のエラーが発生したため ユーザー は保存されませんでした。'

      # （登録成功）
      expect {
        fill_in 'user_name', with: 'sample'
        fill_in 'user_email', with: 'sample@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'アカウント登録'
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      expect(current_path).to eq root_path

      mail = ActionMailer::Base.deliveries.last
      URL = extract_confirmation_url(mail)

      expect(mail.to).to eq ["sample@example.com"]
      expect(mail.subject).to eq "メールアドレス確認メール"
      expect(mail.body).to have_link "メールアドレスの確認"

      # 誤ったURLの時
      invalid_URL = "http://localhost:3000/users/confirmation?confirmation_token=aaaaaaaa"
      visit invalid_URL
      expect(page).to have_content "パスワード確認用トークンは不正な値です"
      expect(page).to have_content "エラーが発生したため ユーザー は保存されませんでした。"

      # 正しいURLの時
      visit URL
      expect(page).to have_content "アカウントを登録しました。"
      user = User.find_by(email: 'sample@example.com')
      expect(current_path).to eq user_path(user)
    end
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end
end
