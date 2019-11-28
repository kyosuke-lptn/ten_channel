class PostingThreadsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @category = Category.find_by id: params[:category]
    @posting_threads = ThreadSearchForm.filter_by_category_or_new_arrival(@category, params[:page])
  end

  def show
    @current_user = current_user
    @posting_thread = PostingThread.find params[:id]
    @comments = @posting_thread.comments.includes(:user)
  end

  def new
    @user = current_user
    @posting_thread = PostingThread.new
    @posting_thread.posting_thread_categories.build
  end

  def create
    @user = current_user
    @posting_thread = PostingThread.create(posting_threads_params)
    if @posting_thread.valid?
      params_categories_ids = categories_params[:category_id]
      params_categories_ids.shift
      params_categories_ids.each do |id|
        PostingThreadCategory.find_or_create_by(category_id: id, posting_thread_id: @posting_thread.id)
      end
      redirect_to @posting_thread, notice: "スレッドを立てました。"
    else
      render 'new'
    end
  end

  def edit
    @posting_thread = current_user.posting_threads.find params[:id]
  end

  def update
    @posting_thread = PostingThread.find params[:id]
    if @posting_thread.update(posting_threads_params)
      params_categories_ids = categories_params[:category_id]
      params_categories_ids.shift
      db_categories = @posting_thread.posting_thread_categories
      db_categories.each do |category|
        category.destroy unless params_categories_ids.include?(category.id)
      end
      params_categories_ids.each do |id|
        PostingThreadCategory.find_or_create_by(category_id: id, posting_thread_id: @posting_thread.id)
      end
      redirect_to @posting_thread, notice: "スレッドを更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
    posting_thread = current_user.posting_threads.find params[:id]
    posting_thread.destroy
    redirect_to root_path, alert: "「#{posting_thread.title}」を削除しました。"
  end

  private

    def posting_threads_params
      params.require(:posting_thread).permit(
        :user_id,
        :title,
        :description,
      )
    end

    def categories_params
      params.require(:posting_thread_categories).permit(category_id: [])
    end
end
