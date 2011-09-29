class ProductsController < ApplicationController
  layout "admin"
  before_filter :require_user
# before_filter :product_feed_source_must_zero, :only => [:new, :create]


  def index
    @products = current_shop.products.order('position')
  end

  def edit
    @product = current_shop.products.find_by_id(params[:id])
    @categories = current_shop.categories
    redirect_to products_path if @product.nil?
  end

  def update
    @product = current_shop.products.find_by_id(params[:id])
    @categories = current_shop.categories
    if @product.update_attributes(params[:product])
      redirect_to products_path
    else
      flash.now[:error] = @product.errors.full_messages.first
      render :edit
    end
  end

  def new
    @categories = current_shop.categories
    @product = current_shop.products.build
    #  1.times { @product.images.build }
  end

  def create
    @categories = current_shop.categories
    @product = current_shop.products.build(params[:product])
    if @product.save
      redirect_to products_path
    else
      flash.now[:error] = @product.errors.full_messages.first
      render :new
    end
  end

  def destroy
    @product = current_shop.products.find_by_id(params[:id])
    @product.destroy
    redirect_to products_path
  end

  def sort
    current_shop.products.all.each do |product|
      if position = params[:products].index(product.id.to_s)
        product.update_attribute(:position, position + 1) unless product.position == position + 1
      end
    end
    render :nothing => true, :status => 200
  end

# private

# def product_feed_source_must_zero
#   if current_shop.products.size > 0 and current_shop.products.first.feed_source != 0
#     redirect_to products_path
#     return false
#   end
# end

end
