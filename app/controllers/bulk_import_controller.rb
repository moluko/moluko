require 'fastercsv'
require 'open-uri'
class BulkImportController < ApplicationController
  layout 'admin'
  before_filter :require_user

  def index
  end

  def csv
    file = params[:csv_import][:file]
    file_string = file.read
    delimiter = params[:csv_import][:delimiter]
    delimiter = ',' if delimiter.blank?

    Delayed::Job.enqueue ImportProductsUsingCSVJob.new(file_string, delimiter, current_shop.id)
    #ImportProductsUsingCSVJob.new(file_string, delimiter, current_shop).perform
    flash[:info] = "Your products bulk import request are being processed now. Please come back later."
    redirect_to products_path
  end

  def big_commerce
    current_user.update_attributes :big_commerce_feed_link => params[:user][:big_commerce_feed_link]
    begin
      net = open(current_user.big_commerce_feed_link)
      if net.instance_of? Tempfile
        logger.info '002 feed started'
        doc = Nokogiri::XML(net)
        products = doc.css("entry")
        products.each do |product|
          title = product.css('title').text
          description = product.css('description').text
          url_to_product = product.css('link').text
          price = product.css('g|price').text.to_d
          department = product.css('g|department').text
          image_link = product.css('g|image_link').text
          feed_id = product.css('g|id').text
          feed_source = 2

          c = current_user.categories.find_by_name(department)
          current_user.categories.create :name => department if c.nil?

          p = current_user.products.feed_source_equals(feed_source).feed_id_equals(feed_id).first
          if p.nil?
            p = current_user.products.build
            p.save( :validate => false )
          end
          p.update_attributes :title => title,
            :description => description,
            :url_to_product => url_to_product,
            :category => c,
            :price => price,
            :feed_id => feed_id,
            :feed_source => feed_source
          i = p.images.find_by_url_to_image(image_link)
          p.images.create :image_url => image_link if i.nil?
        end
        redirect_to products_path
      end
    rescue => exception
      error = ERB::Util.h(exception.to_s)
      #      flash.now[:error] = "Error adding product(s). (#{error}). Please try again."
      flash.now[:error] = "Failed to import products from Big Commerce. Please email questions@moluko.com for help."
      render :action => :index
    end

  end

  def vendasbs
    begin
      logger.info "0001 Venda-SBS"
      logger.info "0002 Starting Venda-SBS FasterCSV"
      file = params[:vendasbs_import][:file]
      product_count = 0
      FasterCSV.parse( file, :headers => true, :col_sep => ',', :row_sep => :auto ) do |row|
        category = current_user.categories.find_by_name(row["Category1"])
        category = current_user.categories.create :name => row["Category1"] if category.nil?
        product = current_user.products.feed_source_equals(3).feed_id_equals(row["SKU"]).first
        if product.nil?
          product = current_user.products.build :feed_id => row["SKU"], :feed_source => 3
          product.save( :validate => false )
        end
        product.update_attributes :title => row["Name"],
          :price => row["PriceNet"].to_d,
          :description => row["ShortDescription"],
          :url_to_product => row["URL"],
          :category => category
        unless row["FullSizeImageURL"].nil?
          i = product.images.find_by_url_to_image(row["FullSizeImageURL"])
          product.images.create :image_url => row["FullSizeImageURL"] if i.nil?
        end
        product_count += 1
      end
      flash[:notice] = "Successfully added #{product_count} product(s)"
      redirect_to products_path
    rescue => exception
      # If an exception is thrown, the transaction rolls back and we end up in this rescue block
      error = ERB::Util.h(exception.to_s) # get the error and HTML escape it
      #      flash.now[:error] = "Error adding product(s).  (#{error}).  Please try again."
      flash.now[:error] = "Failed to import products from Venda. Please email questions@moluko.com for help."
      render :action => :index
    end
  end

  def shopify
    begin
      current_user.update_attributes :shopify_feed_link => params[:user][:shopify_feed_link].strip
      logger.info '001 open shopify'
      net = open(current_user.shopify_feed_link + "/collections/all.atom")
      doc = Nokogiri::XML(net)
      feed_products = doc.css("entry")
      feed_products.each do |feed_product|
        #getting parse data
        feed_title = feed_product.at_css('title').text
        feed_description = feed_product.css('summary').text
        feed_url_to_product = feed_product.css('link').last['href']
        feed_price = feed_product.css('s|price').text.to_d
        feed_category = feed_product.css('s|type').text
        feed_url_to_image = feed_product.at_css('content')['src'] unless feed_product.at_css('content').nil?
        feed_id = feed_product.at_css('id').text
        feed_source = 4

        #starting to add/edit product
        category = current_user.categories.find_by_name(feed_category)
        current_user.categories.create :name => feed_category if category.nil?

        product = current_user.products.feed_source_equals(feed_source).feed_id_equals(feed_id).first
        if product.nil?
          product = current_user.products.build
          product.save( :validate => false )
        end
        product.update_attributes :title => feed_title,
          :description => feed_description,
          :url_to_product => feed_url_to_product,
          :category => category,
          :price => feed_price,
          :feed_id => feed_id,
          :feed_source => feed_source
        image = product.images.find_by_url_to_image(feed_url_to_image)
        product.images.create :image_url => feed_url_to_image if image.nil?
      end
      flash[:notice] = "Successfully added #{feed_products.size} product(s)"
      redirect_to products_path
    rescue => exception
      error = ERB::Util.h(exception.to_s)
      flash.now[:error] = "Error adding product(s). (#{error}). Please try again."
      #flash.now[:error] = "Failed to import products from Shopify. Please email questions@moluko.com for help."
      render :action => :index
    end
  end

  def volusion
    begin
      file = params[:volusion_import][:file]
      doc = Nokogiri::XML(file)
      feed_products = doc.css("Products_Joined")
      feed_products.each do |feed_product|
        feed_title = feed_product.css('productname').text
        feed_description = feed_product.css('productdescriptionshort').text
        feed_url_to_product = feed_product.css('producturl').text
        feed_price = feed_product.css('productprice').text.to_d
        feed_category = feed_product.css('categorytree').text
        feed_url_to_image = feed_product.css('photourl').text
        feed_id = feed_product.css('productcode').text
        feed_source = 5

        category = current_user.categories.find_by_name(feed_category)
        current_user.categories.create :name => feed_category if category.nil?

        product = current_user.products.feed_source_equals(feed_source).feed_id_equals(feed_id).first
        if product.nil?
          product = current_user.products.build
          product.save( :validate => false )
        end
        product.update_attributes :title => feed_title,
          :description => feed_description,
          :url_to_product => feed_url_to_product,
          :category => category,
          :price => feed_price,
          :feed_id => feed_id,
          :feed_source => feed_source
        image = product.images.find_by_url_to_image(feed_url_to_image)
        product.images.create :image_url => feed_url_to_image if image.nil?
      end
      flash[:notice] = "Successfully added #{feed_products.size} product(s)"
      redirect_to products_path
    rescue => exception
      # If an exception is thrown, the transaction rolls back and we end up in this rescue block
      error = ERB::Util.h(exception.to_s) # get the error and HTML escape it
      #      flash.now[:error] = "Error adding product(s). (#{error}). Please try again."
      flash.now[:error] = "Failed to import products from Volusion. Please email questions@moluko.com for help."
      render :action => :index
    end
  end

  private

end
