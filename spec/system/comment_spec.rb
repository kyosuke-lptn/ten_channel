require 'rails_helper'

RSpec.describe "PostThread", type: :system, js: true do
  let!(:posting_thread) { create(:posting_thread) }
  let!(:comment) { create(:comment, posting_thread_id: posting_thread.id) }

  it "スレッドに対して書き込みや高評価をつけるテスト" do
    sign_in posting_thread.user
    visit posting_thread_path(posting_thread)
    aggregate_failures do
      expect(page).to have_content comment.content

      fill_in 'comment_content', with: "I am happy"
      click_button 'コメント'
      expect(page).to have_content 'I am happy'

      within first(".like-#{comment.id}") do
        click_link "thumb_up"
      end
      expect(page).to have_css '.text-lighten-1'

      within first(".like-#{comment.id}") do
        click_link "thumb_up"
      end
      expect(page).not_to have_css '.text-lighten-1'
    end
  end
end
