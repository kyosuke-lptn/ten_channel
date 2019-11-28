class ThreadSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :word, :string
  attribute :categories

  def search
    if categories.blank? && word.blank?
      return []
    elsif categories == [""] || categories.blank?
      categories_name = Category.pluck(:name)
    else
      categories_name = categories.pluck(:name)
    end
    scope = PostingThread.filter_by_categories(categories_name)
    return scope if word.blank?
    scope.text_match(word)
  end

  def self.filter_by_category_or_new_arrival(category, page)
    if category
      PostingThread.
        eager_load(:comments).
        filter_by_categories(category.name).
        paginate(page: page, per_page: 24).
        order(created_at: :desc)
    else
      PostingThread.
        eager_load(:comments).
        paginate(page: page, per_page: 24).
        order(created_at: :desc)
    end
  end
end
