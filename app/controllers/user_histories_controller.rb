class UserHistoriesController < ApplicationController
  layout 'admin'
  before_filter :require_admin_user

  def index
    @user = User.find_by_id params[:user_id]
    @user_histories = @user.user_histories.order('created_at desc').paginate :page => params[:page], :per_page => 30
  end

  def all_user_histories
    @user_histories = UserHistory.order('created_at desc').paginate :per_page => 30, :page => params[:page]
  end

end
