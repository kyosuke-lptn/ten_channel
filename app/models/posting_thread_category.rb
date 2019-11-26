class PostingThreadCategory < ApplicationRecord
  belongs_to :posting_thread, inverse_of: :posting_thread_categories
  belongs_to :category, inverse_of: :posting_thread_categories

  validates :posting_thread_id, presence: true, uniqueness: { scope: :category_id }
  validates :category_id, presence: true
end
