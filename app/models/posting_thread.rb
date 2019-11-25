class PostingThread < ApplicationRecord
  has_many :comments
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :user_id, presence: true
end
