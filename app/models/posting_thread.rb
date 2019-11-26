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

  def self.text_match(words)
    return [] if words.blank?
    regexp = "%#{words.strip.gsub(/[ 　\t]+/, "%")}%"
    threads = PostingThread.
      joins(:comments).
      where("#{PostingThread.table_name}.title Like :this OR #{PostingThread.table_name}.description Like :this OR #{Comment.table_name}.content Like :this", this: regexp).
      select("#{PostingThread.table_name}.*, count(#{Comment.table_name}.id) as comments_count").
      group(:id).
      order("comments_count desc")
  end
end
