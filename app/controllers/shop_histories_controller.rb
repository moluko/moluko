class ShopHistoriesController < ApplicationController
  layout 'admin'
  before_filter :require_admin_user

  def index
    @shop = Shop.find_by_id params[:shop_id]
    @shop_histories = @shop.shop_histories.order('created_at desc').paginate :page => params[:page], :per_page => 30
  end

  def all_shop_histories
    @shop_histories = ShopHistory.order('created_at desc').paginate :page => params[:page], :per_page => 30
  end

end
