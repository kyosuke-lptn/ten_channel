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

  context 'PostThreadのカテゴリー別と新着ページ'
  let!(:posting_thread_without_category) { create(:posting_thread, created_at: Time.current) }
  let!(:posting_thread_with_category) { create(:posting_thread_with_category, created_at: 2.hours.ago) }

  it "ページの確認" do
    visit root_path
    click_link '新着スレ'
    expect(page).to have_content posting_thread_without_category.title
    expect(page).to have_content posting_thread_with_category.title

    visit root_path
    click_link posting_thread_with_category.categories[0].name
    expect(page).to have_content posting_thread_with_category.title
    expect(page).not_to have_content posting_thread_without_category.title
  end
end
