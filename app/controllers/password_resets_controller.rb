class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user

  def index
    redirect_to new_password_reset_path
  end

  def new
  end

  def edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.password.empty?
      render :action => :edit and return
    end

    if @user.save
      flash[:info] = "Password successfully updated"
      redirect_to products_path
    else
      flash.now[:error] = @user.errors.full_messages.first
      render :action => :edit
    end
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash.now[:info] = "Instructions to reset your password have been emailed to you. Please check your email."
    else
      flash.now[:error] = "No user was found with that email address"
    end
    render :action => :new
  end

  private

  def load_user_using_perishable_token
    @user = User.find_by_perishable_token(params[:id])
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account. " +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to login_path
    end
  end
end
