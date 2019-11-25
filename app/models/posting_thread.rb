class PostingThread < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :posting_thread_categories, dependent: :destroy, inverse_of: :posting_thread
  has_many :categories,
            through: 'posting_thread_categories',
            source: 'category'
  accepts_nested_attributes_for :posting_thread_categories
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :user_id, presence: true
end
