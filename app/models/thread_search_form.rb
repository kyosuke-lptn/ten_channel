class ThreadSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :word, :string
  attribute :categories

  def search
    return [] if word.blank?

    if categories == [""] || categories.blank?
      categories_name = Category.pluck(:name)
    else
      categories_name = categories.pluck(:name)
    end

    scope = PostingThread.text_match(word)
    scope.filter_by_categories(categories_name)
  end
end
