class SearchController < ApplicationController
  def create
    @categories = Category.where(id: params[:categories])
    @search_form = ThreadSearchForm.new(
      word: params[:search_word],
      categories: @categories
    )
    @threads = @search_form.search
    render 'show'
  end
end
