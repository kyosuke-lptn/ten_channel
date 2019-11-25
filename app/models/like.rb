class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :user_id, presence: true, uniqueness: { scope: :comment_id }
  validates :comment_id, presence: true
  validate :only_word

  private

    def only_word
      unless (good_or_bad == "good") || (good_or_bad == "bad") || good_or_bad.blank?
        errors.add(:good_or_bad, "goodまたはbadしか入力できません。")
      end
    end
end
