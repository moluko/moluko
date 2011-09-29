class CategoriesController < ApplicationController
  layout 'admin'
  before_filter :require_user

  def index
    @categories = current_shop.categories.order('position')
  end

  def destroy
    @category = current_shop.categories.find(params[:id])
    redirect_to categories_path and return if @category.nil?
    Product.where('category_id = ?', @category.id).each do |product|
      product.update_attributes :category_id => 0
    end
    @category.destroy
    redirect_to categories_path
  end

  def edit
    @category = current_shop.categories.find(params[:id])
    redirect_to categories_path if @category.nil?
  end

  def update
    @category = current_shop.categories.find(params[:id])
    redirect_to categories_path and return if @category.nil?
    if @category.update_attributes(params[:category])
      redirect_to categories_path
    else
      flash.now[:error] = @category.errors.full_messages.first
      render :edit
    end
  end

  def create
    @category = current_shop.categories.build(params[:category])
    if @category.save
      redirect_to categories_path
    else
      flash.now[:error] = @category.errors.full_messages.first
      @categories = current_shop.categories
      render :new
    end
  end

  def new
    @category = Category.new
  end

  def sort
    current_shop.categories.all.each do |category|
      if position = params[:categories].index(category.id.to_s)
        category.update_attribute(:position, position + 1) unless category.position == position + 1
      end
    end
    render :nothing => true, :status => 200
  end

end
