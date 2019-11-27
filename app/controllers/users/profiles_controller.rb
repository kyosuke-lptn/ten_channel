class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = current_user
    @posting_thread = @user.posting_threads.eager_load(:comments).order('posting_threads.created_at').order('comments.updated_at desc')
  end
end
