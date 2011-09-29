class SalesController < ApplicationController
  layout 'admin'
  before_filter :require_user

  def index
    #@orders = current_shop.orders.payment_status_equals('Completed').descend_by_created_at.paginate :per_page => 25, :page => params[:page]
    @orders = current_shop.orders.order('created_at desc').paginate :per_page => 25, :page => params[:page]
  end

  def show
    @order = current_shop.orders.find_by_position params[:id]
    #@specifications = @order.specifications.gsub(/^\(/,"").gsub(/\)$/,"").split(", ")
    redirect_to sales_path and return unless @order.payment_status == "Completed"
  end

  def update_shipping_status
    @order = current_shop.orders.find_by_position params[:id]
    if @order.shipping_status == "1"
      @order.update_attributes :shipping_status => "0"
    else
      @order.update_attributes :shipping_status => "1"
    end
    render :text => @order.shipping_status
  end

end
