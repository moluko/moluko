# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user, :current_shop
  helper_method :logged_in?

  before_filter :set_time_zone
  before_filter :log_user_history

  private

  def log_user_history
    unless current_user.nil?
      unless current_user.id == 25 or current_user.id == 26
        current_user.user_histories.create :remote_ip => request.remote_ip,
          :controller => params[:controller],
          :action => params[:action],
          :params => params.map{|key, value| ["#{key} => #{value}"]}.join(" | ")
      end
    end
  end

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_shop
    return @current_shop if defined?(@current_shop)
    @current_shop = current_user.shops.order('position').first
  end

  def require_admin_user
    unless current_user
      current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    else
      render :nothing => true, :status => 404 unless current_user.role? :admin
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to getstarted_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
