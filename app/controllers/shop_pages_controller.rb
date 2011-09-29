class ShopPagesController < ApplicationController
  layout 'admin'

  def index
    @shop_pages = current_shop.shop_pages
  end

  def new
    @shop_page = current_shop.shop_pages.build
  end

  def edit
    @shop_page = current_shop.shop_pages.find_by_id params[:id]
  end

  def create
    @shop_page = current_shop.shop_pages.build params[:shop_page]
    if @shop_page.save
      redirect_to edit_shop_page_path(@shop_page)
    else
      render :new
    end
  end

  def update
    @shop_page = current_shop.shop_pages.find_by_id params[:id]
    if @shop_page.update_attributes params[:shop_page]
      redirect_to edit_shop_page_path(@shop_page)
    else
      render :edit
    end
  end

end
