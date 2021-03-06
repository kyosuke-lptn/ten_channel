class Category < ApplicationRecord
  has_many :posting_thread_categories, inverse_of: :category
  has_many :posting_threads,
            through: 'posting_thread_categories',
            source: 'posting_thread'

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
end
