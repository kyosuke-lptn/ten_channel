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
end
