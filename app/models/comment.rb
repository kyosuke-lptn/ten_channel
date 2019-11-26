class Comment < ApplicationRecord
  has_many :likes, dependent: :destroy
  belongs_to :user
  belongs_to :posting_thread, touch: true, inverse_of: :comments

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

  def good_count
    likes.where(good_or_bad: "good").length
  end

  def bad_count
    likes.where(good_or_bad: "bad").length
  end
end
