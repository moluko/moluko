class Facebook::PageController < ApplicationController

  layout 'facebook'

  after_filter :log_shop_history

  def index
  end

  def calculate_shipping
    assign_variable
    find_shop
    find_cart

    @total_weight = 0
    @cart.cart_items.each do |cart_item|
      if cart_item.product.free_shipping == '0'
        @total_weight += cart_item.product.weight * cart_item.quantity
      end
    end

    if @total_weight == 0 or @cart.shop.shipping_plans.size == 0
      shipping_fee = 0
    else
      country = Country.find_by_name params[:country].upcase
      country = country.nil? ? '*' : country.iso3
      region = params[:region].upcase
      zipcode = params[:zipcode].upcase
      delivery_type = params[:delivery_type]

      @shipping_plan = @shop.shipping_plans.find( :all, :conditions => ["country = ? and region = ? and zipcode = ? and delivery_type = ? and range1 <= ? and range2 >= ?", country, region, zipcode, delivery_type, @total_weight, @total_weight] ).first
      if @shipping_plan.nil?
        zipcode = '*'
        @shipping_plan = @shop.shipping_plans.find( :all, :conditions => ["country = ? and region = ? and zipcode = ? and delivery_type = ? and range1 <= ? and range2 >= ?", country, region, zipcode, delivery_type, @total_weight, @total_weight] ).first
        if @shipping_plan.nil?
          region = '*'
          @shipping_plan = @shop.shipping_plans.find( :all, :conditions => ["country = ? and region = ? and zipcode = ? and delivery_type = ? and range1 <= ? and range2 >= ?", country, region, zipcode, delivery_type, @total_weight, @total_weight] ).first
          if @shipping_plan.nil?
            country = '*'
            @shipping_plan = @shop.shipping_plans.find( :all, :conditions => ["country = ? and region = ? and zipcode = ? and delivery_type = ? and range1 <= ? and range2 >= ?", country, region, zipcode, delivery_type, @total_weight, @total_weight] ).first
          end
        end
      end
      if @shipping_plan.nil?
        shipping_fee = nil
      else
        shipping_fee = @shipping_plan.price
      end
    end

    @cart.country = params[:country]
    @cart.region = params[:region]
    @cart.zipcode = params[:zipcode]
    @cart.delivery_type = params[:delivery_type]
    @cart.shipping_fee = shipping_fee
    @cart.save
  end

  def show_calculate_shipping_dialog
    assign_variable
    find_shop
    find_cart
    @delivery_types = @shop.shipping_plans.find(:all, :select => "DISTINCT delivery_type").collect(&:delivery_type)
    @countries = @shop.shipping_plans.find(:all, :select => "DISTINCT country").collect(&:country_name).sort
  end

  def delete_cart_item
    assign_variable
    find_shop
    find_cart
    @cart_item = @cart.cart_items.find_by_product_id params[:product_id]
    @cart_item.destroy
    @cart.shipping_fee = nil
    @cart.save
  end

  def add_to_cart
    assign_variable
    find_shop
    find_cart
    @cart = @shop.carts.create :fb_ids => params[:fb_user_id] if @cart.nil?
    @cart.cart_items.create :product_id => params[:product_id], :quantity => params[:quantity]
    @cart.shipping_fee = nil
    @cart.save
  end


  def show_add_to_cart_dialog
    assign_variable
    find_shop
    @product = @shop.products.find_by_id params[:product_id]
    respond_to do |format|
      format.js
    end
  end

  def show_cart
    assign_variable
    find_shop
    find_cart

    respond_to do |format|
      format.js
    end
  end

  def show
    assign_variable
    find_shop
    find_page

    unless @shop.nil?
      generate_liquid_data
      @shop.shop_logs.create unless @fb_page_admin
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    signed_request = decode_data params[:signed_request]
    @signed_request = decode_data params[:signed_request]
    @fb_page_admin = signed_request['page']['admin']
    @fb_page_id = signed_request['page']['id']
    @fb_user_id = signed_request['user_id']
    @fb_page_liked = signed_request['page']['liked']
    @fb_app_id = APP_CONFIG[:fb_app_id]

    find_shop
    find_page

    unless @shop.nil?
      generate_liquid_data
      @shop.shop_logs.create unless @fb_page_admin
    end

  end

  def edit
    @fb_id = params[:id]
  end

  def update
    shop = Shop.find_by_activation_key params[:activation_key]
    unless shop.nil?
      shop.fb_ids = params[:id]
      shop.save( :validate => false )
    end
    @fb_page_url = fb_page_url(shop.fb_ids)
    #redirect_to fb_page_url(shop.fb_ids)
  end

  def close
  end

  private

  def find_page
    if @shop.nil? or @shop.theme_id.nil?
      @theme = Theme.order('position').first
      if params[:page_request].nil?
        @page = @theme.theme_pages.order('id').first.content
      else
        @page = @theme.theme_pages.find_by_name(params[:page_request]).content
      end
    elsif @shop.theme_id == 0
      if params[:page_request].nil?
        @page = @shop.shop_pages.first.content
      else
        @page = @shop.shop_pages.find_by_name(params[:page_request]).content
      end
    else
      @theme = Theme.find_by_id @shop.theme_id
      if params[:page_request].nil?
        @page = @theme.theme_pages.order('id').first.content
      else
        @page = @theme.theme_pages.find_by_name(params[:page_request]).content
      end
    end
  end

  def find_shop
    @shop = Shop.find_by_fb_ids @fb_page_id

    if @shop.nil?
      if @fb_page_admin
        redirect_to edit_facebook_page_path(@fb_page_id) and return
      else
        redirect_to close_facebook_page_index_path and return
      end

    elsif @shop.status == 0
      redirect_to close_facebook_page_index_path and return
    end
  end

  def base64_url_decode(str)
    encoded_str = str.gsub('-','+').gsub('_','/')
    encoded_str += '=' while !(encoded_str.size % 4).zero?
    Base64.decode64(encoded_str)
  end

  def decode_data(str)
    encoded_sig, payload = str.split('.')
    data = ActiveSupport::JSON.decode base64_url_decode(payload)
  end

  def fb_page_url(fb_page_id)
    "http://www.facebook.com/pages/#{fb_page_id}/#{fb_page_id}?sk=app_#{APP_CONFIG[:fb_app_id]}"
  end

  def generate_liquid_data
    categories_per_page = 30
    categories_maximum_pagination_range = 10
    products_per_page = 4
    products_maximum_pagination_range = 10

    @data = Hash.new

    #default value
    @data['current_category_id'] =  params[:current_category_id].nil? ? '0' : params[:current_category_id]
    @data['current_categories_page'] = params[:current_categories_page].nil? ? '1' : params[:current_categories_page]
    @data['current_product_id'] = params[:current_product_id].nil? ? '0' : params[:current_product_id]
    @data['current_products_page'] = params[:current_products_page].nil? ? '1' : params[:current_products_page]

    #checking posting params

    unless params[:category_id].nil?
      @data['current_category_id'] = params[:category_id]
      @data['current_products_page'] = '1'
    end

    unless params[:categories_page].nil?
      @data['current_categories_page'] = params[:categories_page]
    end

    unless params[:product_id].nil?
      @data['current_product_id'] = params[:product_id]
    end

    unless params[:products_page].nil?
      @data['current_products_page'] = params[:products_page]
    end

    #create variable for categories
    @data['categories'] = @shop.categories.paginate :per_page => categories_per_page, :page => @data['current_categories_page'], :order => "position"
    @data['categories_size'] = @shop.categories.size.to_s
    @data['categories_page_size'] = (@data['categories_size'].to_f / categories_per_page).ceil.to_s
    @data['categories_pagination_range'] = calculate_pagination_range( @data['current_categories_page'], @data['categories_page_size'], @data['categories_size'], categories_per_page, categories_maximum_pagination_range )
    @data['current_category'] = @shop.categories.find_by_id @data['current_category_id']

    #create variable for products
    if @data['current_category_id'] == '0'
      all_products = @shop.products.find :all, :order => "position"
      group_products = []
      all_products.each do |i|
        if i.group_specification.blank?
          group_products << i
        else
          group_products << i if group_products.select{|j| j.group_specification == i.group_specification}.size == 0
        end
      end

      @data['products'] = group_products[(@data['current_products_page'].to_i - 1) * products_per_page, products_per_page]
      #      @data['products'] = @shop.products.paginate :all, :order => "position", :per_page => products_per_page, :page => @data['current_products_page']
      @data['products_size'] = group_products.size
    else
      all_products = @shop.products.find :all, :order => "position", :conditions => { :category_id => @data['current_category_id'] }
      group_products = []
      all_products.each do |i|
        if i.group_specification.blank?
          group_products << i
        else
          group_products << i if group_products.select{|j| j.group_specification == i.group_specification}.size == 0
        end
      end

      @data['products'] = group_products[(@data['current_products_page'].to_i - 1) * products_per_page, products_per_page]
      #@data['products'] = @shop.products.paginate :all, :order => "position", :conditions => { :category_id => @data['current_category_id'] }, :per_page => products_per_page, :page => @data['current_products_page']
      @data['products_size'] = @shop.products.find(:all, :conditions => { :category_id => @data['current_category_id'] }).size
    end
    @data['products_page_size'] = (@data['products_size'].to_f / products_per_page).ceil.to_s
    @data['products_pagination_range'] = calculate_pagination_range( @data['current_products_page'], @data['products_page_size'], @data['products_size'], products_per_page, products_maximum_pagination_range )
    @data['current_product'] = @shop.products.find_by_id @data['current_product_id']

    unless @data['current_product'].nil?
      unless @data['current_product'].group_specification.blank?
        @data['current_product_variant'] = @shop.products.find_all_by_group_specification @data['current_product'].group_specification
        @data['current_product_variant'].delete(@data['current_product'])
      end
    end

    #create misc variable
    @data['domain_name'] = APP_CONFIG[:domain_name]
    @data['currency_symbol'] = @shop.paypal_currency_symbol

    @data['theme_images'] = @theme.theme_images
    @data['facebook_page_url'] = fb_page_url(@shop.fb_ids)
  end

  def calculate_pagination_range( current_page, page_size, model_size, per_page, maximum_pagination_range )
    current_page = current_page.to_i
    page_size = page_size.to_i
    model_size = model_size.to_i
    paginate_half_range = maximum_pagination_range / 2
    paginate_start = current_page.to_i - paginate_half_range
    paginate_end = current_page.to_i + paginate_half_range
    if paginate_start < 1
      paginate_end += paginate_start.abs
      paginate_start = 1
    end
    if paginate_end > page_size
      paginate_start += page_size - paginate_end
      paginate_end = page_size
    end
    paginate_start = 1 if paginate_start < 1
    paginate_end = page_size if paginate_end > page_size
    (paginate_start..paginate_end).map{|page| page.to_s}
  end

  def find_cart
    @cart = @shop.carts.find_by_fb_ids @fb_user_id
  end

  def assign_variable
    @fb_page_id = params[:id]
    @fb_user_id = params[:fb_user_id]
    @fb_page_admin = params[:fb_page_admin]
    @fb_page_liked = params[:fb_page_liked]
    @replace_tag = params[:replace_tag]
  end

  def log_shop_history
    unless @shop.nil?
      @shop.shop_histories.create :controller => params[:controller],
        :action => params[:action],
        :params => params.map{|key, value| ["#{key} => #{value}"]}.join(" | ")
    end
  end

end
