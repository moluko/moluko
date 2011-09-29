class OrdersController < ApplicationController
  layout 'admin'
  before_filter :require_admin_user

  def index
    @orders = current_shop.orders.descend_by_created_at
  end

end
