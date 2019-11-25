class Category < ApplicationRecord
  has_many :posting_thread_categorys

  validates :name, presence: true, length: { maximum: 20 }
end
