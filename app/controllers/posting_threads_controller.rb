class PostingThreadsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @current_user = current_user
    @posting_thread = PostingThread.find params[:id]
    @comments = @posting_thread.comments.includes(:user)
  end

  def new
    @user = current_user
    @posting_thread = PostingThread.new
  end

  def create
    @user = current_user
    @posting_thread = @user.posting_threads.build(posting_threads_params)
    if @posting_thread.save
      redirect_to @posting_thread, notice: "スレッドを立てました。"
    else
      render 'new'
    end
  end

  def edit
    @posting_thread = current_user.posting_threads.find params[:id]
  end

  def update
    @posting_thread = current_user.posting_threads.find params[:id]
    if @posting_thread.update(posting_threads_params)
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
      params.require(:posting_thread).permit(:user_id, :title, :description)
    end
end
