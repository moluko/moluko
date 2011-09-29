class PagesController < ApplicationController
  helper PagesHelper
  before_filter :require_user, :only => [ :getstarted, :help ]
  before_filter :require_admin_user, :only => [ :dashboard ]

  def dashboard
    @shops = Shop.order('user_id desc')
    render :layout => 'admin'
  end

  def getstarted
    render :layout => 'admin'
  end

  def help
    render :layout => 'admin'
  end

  def home
    redirect_to getstarted_path and return unless current_user.nil?
  end

  def pricing
    redirect_to getstarted_path and return unless current_user.nil?
  end

end
