class Comment < ApplicationRecord
  has_many :likes, dependent: :destroy
  belongs_to :user
  belongs_to :posting_thread

  validates :content, presence: true, length: { maximum: 200 }
  validates :user_id, presence: true
  validates :posting_thread_id, presence: true

  def good_or_bad?(user)
    like = likes.where(user_id: user.id).first
    like ? like.good_or_bad : ""
  end

  def poster
    user.name
  end
end
