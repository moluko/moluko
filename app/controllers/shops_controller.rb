class ShopsController < ApplicationController
  layout 'admin'
  before_filter :require_user
  #before_filter :require_reseller_user, :only => [ :new, :create ]

  def index
    @shops = current_user.shops.order('position')
  end

  def show
    redirect_to edit_shop_path(:current)
  end

  def new
    @shop = current_user.shops.build
  end

  def create
    @shop = current_user.shops.build params[:shop]
    if @shop.save
      redirect_to shops_path
    else
      flash.now[:error] = @shop.errors.full_messages.first
      render :new
    end
  end

  def themes
    @themes = Theme.order('position')
  end

  def switch_theme
    current_shop.theme_id = params[:theme_id]
    current_shop.save( :validate => false )
    redirect_to themes_shop_path(current_shop)
  end

  def switch_shop
    recent_shop = current_user.shops.find_by_id params[:id]
    current_user.shops.order('position').each do |shop|
      if shop.position < recent_shop.position
        shop.position += 1
        shop.save( :validate => false )
      end
    end
    recent_shop.position = 1
    recent_shop.save( :validate => false )
    redirect_to edit_shop_path(recent_shop)
  end

  def payment
  end

  def edit
  end

  def update
    current_shop.attributes = params[:shop]
    if current_shop.save( :validate => false )
      redirect_to edit_shop_path(current_shop)
    else
      flash.now[:error] = current_shop.errors.full_messages.first
      render :edit
    end
  end

  def update_payment
    if current_shop.update_attributes params[:shop]
      flash[:info] = 'Your payment details has been successfully updated.'
      redirect_to payment_shop_path(:current)
    else
      flash.now[:error] = current_shop.errors.full_messages.first
      render :payment
    end
  end

  private

  # def require_reseller_user
  #   render(:nothing => true, :status => 404) and return false unless current_user.role? :reseller
  #   return true
  # end

end
