require 'rails_helper'

RSpec.describe "SignInAndOuts", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  it "ユーザー登録" do
    visit new_user_registration_path
    aggregate_failures do
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
      confirmation_url = extract_confirmation_url(mail)

      expect(mail.to).to eq ["sample@example.com"]
      expect(mail.subject).to eq "メールアドレス確認メール"
      expect(mail.body).to have_link "メールアドレスの確認"

      # 誤ったURLの時
      invalid_URL = "http://localhost:3000/users/confirmation?confirmation_token=aaaaaaaa"
      visit invalid_URL
      expect(page).to have_content "パスワード確認用トークンは不正な値です"

      invalid_URL_2 = "http://localhost:3000/users/confirmation"
      visit invalid_URL_2
      expect(page).to have_content "パスワード確認用トークンを入力してください"

      # 正しいURLの時
      visit confirmation_url
      expect(page).to have_content "アカウントを登録しました。"
      expect(current_path).to eq profiles_path
    end
  end

  it "アカウント承認メールを再送する" do
    visit new_user_registration_path
    fill_in 'user_name', with: 'sample'
    fill_in 'user_email', with: 'sample@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'アカウント登録'

    visit profiles_path
    aggregate_failures do
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      fill_in 'user_email', with: 'sample@example.com'
      fill_in 'user_password', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'メールアドレスの本人確認が必要です。'
      click_link 'アカウント確認のメールを受け取っていませんか？'

      expect(page).to have_content 'アカウント認証メールを再度送信します'
      expect{
        fill_in 'user_email', with: 'wrong@mail.com'
        click_button '送信'
      }.to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(page).to have_content 'Eメールは見つかりませんでした。'

      expect {
        fill_in 'user_email', with: 'sample@example.com'
        click_button '送信'
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡します。'

      mail = ActionMailer::Base.deliveries.last
      confirmation_url = extract_confirmation_url(mail)

      visit confirmation_url
      expect(page).to have_content "アカウントを登録しました。"
      expect(current_path).to eq profiles_path
    end
  end

  let(:user) { create(:user) }

  it "ユーザー編集と削除" do
    sign_in user
    visit edit_user_registration_path

    fill_in 'user_name', with: 'change-name'
    click_button 'アカウント更新'
    expect(page).to have_content '現在のパスワードを入力してください'

    fill_in 'user_name', with: 'change-name'
    fill_in 'user_current_password', with: user.password
    click_button 'アカウント更新'
    expect(page).to have_content 'アカウント情報を変更しました。'

    visit edit_user_registration_path
    click_link 'アカウントを削除する'
    expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end
end
