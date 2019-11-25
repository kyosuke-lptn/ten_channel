class PostingThread < ApplicationRecord
  has_many :comments
  has_many :posting_thread_categorys
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :user_id, presence: true
end
