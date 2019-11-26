require 'rails_helper'

RSpec.describe "PostThread", type: :system do
  let!(:posting_thread) { create(:posting_thread) }
  let!(:caetgory) { create(:category) }

  it "スレッド投稿までの流れ" do
    sign_in posting_thread.user
    visit root_path
    aggregate_failures do
      expect(page).to have_content '色んな話題についてみんなで語り合おう！！'

      click_link 'スレを立てる'
      expect(page).to have_content 'スレを立てよう！！'

      click_button '新しいスレッド作成'
      expect(page).to have_content 'エラーが発生したため スレッド は保存されませんでした。'

      fill_in 'posting_thread_title', with: posting_thread.title
      fill_in 'posting_thread_description', with: posting_thread.description
      click_button '新しいスレッド作成'
      expect(page).to have_content 'スレッドを立てました。'

      find('.edit-thred-link').click
      expect(page).to have_content 'スレッド編集'

      fill_in 'posting_thread_title', with: ""
      click_button 'スレッド更新'
      expect(page).to have_content 'タイトルを入力してください'

      fill_in 'posting_thread_title', with: "変更したタイトル"
      click_button 'スレッド更新'
      expect(page).to have_content 'スレッドを更新しました。'

      find('.edit-thred-link').click
      click_link 'スレッド削除'
      expect(page).to have_content "「変更したタイトル」を削除しました。"
    end

  end

  it "ゲストユーザーのスレッド詳細ページ確認" do
    visit posting_thread_path(posting_thread)
    expect(page).not_to have_css '.edit-thred-link'
  end
end
