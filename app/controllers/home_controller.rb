class HomeController < ApplicationController
  def index
    @categories = Category.eager_load(:posting_threads).order('posting_threads.updated_at')
  end
end
