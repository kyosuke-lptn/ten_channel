class PostingThreadCategory < ApplicationRecord
  belongs_to :posting_thread
  belongs_to :category

  validates :posting_thread_id, presence: true, uniqueness: { scope: :category_id }
  validates :category_id, presence: true
end
