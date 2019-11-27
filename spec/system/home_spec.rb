require 'rails_helper'

RSpec.describe "Home", type: :system do
  let!(:posting_thread) { create(:posting_thread, updated_at: Time.current) }
  let!(:old_posting_thread) { create(:posting_thread, updated_at: 2.hours.ago) }
  let!(:category) { create(:category) }

  before do
    PostingThreadCategory.create(
      posting_thread_id: posting_thread.id,
      category_id: category.id
    )
    PostingThreadCategory.create(
      posting_thread_id: old_posting_thread.id,
      category_id: category.id
    )
  end

  it "カテゴリー別の表示がスレッドの更新が新しい順で並ぶ" do
    visit root_path
    display_category = all('.category li')
    aggregate_failures do
      within display_category[0] do
        expect(page).to have_content category.name
      end
      within display_category[1] do
        expect(page).to have_content posting_thread.title
      end
      within display_category[2] do
        expect(page).to have_content old_posting_thread.title
      end
    end
  end
end
