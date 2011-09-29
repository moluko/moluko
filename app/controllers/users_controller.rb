class UsersController < ApplicationController
  layout 'admin'
  before_filter :require_user
  before_filter :require_admin_user, :only => [ :index, :new, :create ]

  def index
    @users = User.order('id')
  end

  def show
    redirect_to edit_user_path(current_user)
  end

  def edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.roles = ["end"]
    if @user.save
      redirect_to users_path
    else
      flash.now[:error] = @user.errors.full_messages.first
      render :new
    end
  end

  def update
    @user = current_user
    @user.update_attributes(params[:user])
    if @user.valid?
      flash[:info] = 'Your user details has been successfully updated.'
      redirect_to current_user
    else
      flash.now[:error] = @user.errors.full_messages.first
      render :edit
    end
  end
end
