class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash.now[:notice] = "Successfully logged in."
      redirect_back_or_default getstarted_path
    else
      flash.now[:error] = @user_session.errors.full_messages.first
      render :action => :new
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash.now[:notice] = "Successfully logged out."
    redirect_to root_path
  end
end
