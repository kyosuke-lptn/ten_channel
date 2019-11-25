class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :like]

  def create
    @posting_thread = PostingThread.find params[:comment][:posting_thread_id]
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def like
    if @like = Like.find_by(user_id: current_user.id, comment_id: params[:like][:comment_id])
      @like.update(good_or_bad: params[:like][:good_or_bad])
    else
      @like = current_user.likes.new(like_params)
      @like.save
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :posting_thread_id)
    end

    def like_params
      params.require(:like).permit(:good_or_bad, :comment_id)
    end
end
