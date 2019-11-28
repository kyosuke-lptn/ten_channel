class PostingThread < ApplicationRecord
  has_many :comments, dependent: :destroy, inverse_of: :posting_thread
  has_many :posting_thread_categories, dependent: :destroy, inverse_of: :posting_thread
  has_many :categories,
            through: 'posting_thread_categories',
            source: 'category'
  accepts_nested_attributes_for :posting_thread_categories
  belongs_to :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :user_id, presence: true
  scope :filter_by_categories, ->(categories_name) do
    self.joins(:categories).
      where("#{Category.table_name}.name IN (?)", categories_name)
  end

  scope :recent, ->(display_amount) { order(created_at: 'desc').limit(display_amount) }
  scope :filter_by_words_with_exclusion, ->(regexp_word, exclusion_ids) do
    joins(:comments, :categories).
      where("#{PostingThread.table_name}.title Like :this OR #{PostingThread.table_name}.description Like :this OR #{Comment.table_name}.content Like :this OR #{Category.table_name}.name Like :this", this: regexp_word).
      where.not(id: exclusion_ids).
      select("#{PostingThread.table_name}.*, count(#{Comment.table_name}.id) as comments_count").
      group(:id).order("comments_count desc")
  end

  def self.text_match(words)
    regexp =  words.split(/[ 　\t]/).map{ |a| "%#{a.strip}%" }
    exclusion_ids = []
    threads = []
    regexp.each do |regexp_word|
      threads << PostingThread.filter_by_words_with_exclusion(regexp_word, exclusion_ids)
      exclusion_ids << threads.flatten.map(&:id).uniq
    end
    threads.flatten
  end

  def rating
    self.all_good_count - self.all_bad_count
  end

  def all_good_count
    all_count = 0
    comments.each do |comment|
      all_count += comment.good_count
    end
    all_count
  end

  def all_bad_count
    all_count = 0
    comments.each do |comment|
      all_count += comment.bad_count
    end
    all_count
  end

  def user?(current_user)
    self.user == current_user
  end
end
