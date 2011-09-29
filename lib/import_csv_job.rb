require 'fastercsv'

class ImportCSVJob < Struct.new(:csv_data, :shop)

  def perform
    #mark old product
    products_status = Hash.new
    shop.products.each do |product|
      products_status[product.id] = 0
    end

    #mark old category
    categories_status = Hash.new
    shop.categories.each do |category|
      categories_status[category.id] = 0
    end

    #checking csv delimiter
    delimiter = csv_data[2,1] == "," ? "," : ";"

    #iterate csv data
    FasterCSV.parse( csv_data, :headers => true, :col_sep => delimiter, :row_sep => :auto ) do |row|
      #get feed data
      feed_id = row["no"].to_i
      feed_category = row["category"].nil? ? "uncategorized" : row["category"]
      feed_title = row["title"]
      feed_price = row["price"]
      feed_description = row["description"]
      feed_url_to_product = row["url_to_product"]

      #create or update category
      category = shop.categories.find_by_name(feed_category)
      category = shop.categories.build if category.nil?
      category.name = feed_category
      if category.save
        categories_status[category.id] = 1
      else
        description = "Category No. #{feed_id} : "
        description += category.errors.full_messages.join(", ")
        #shop.message_boards.create :description => description
      end

      #create or update product
      product = shop.products.feed_source_equals(1).feed_id_equals(feed_id).first
      product = shop.products.build if product.nil?
      product.title = feed_title
      product.price = feed_price
      product.description = feed_description
      product.url_to_product = feed_url_to_product
      product.category = category
      product.feed_source = 1
      if product.save
        products_status[product.id] = 1
      else
        description = "Product No. #{feed_id} : "
        description += product.errors.full_messages.join(", ")
        #shop.message_boards.create :description => description
      end

      #create or update product images
      (1..5).to_a.each do |x|
        feed_image = row["url_to_image#{x}"]
        unless feed_image.nil?
          image = product.images.find_by_url_to_image(feed_image)
          image = product.images.build if image.nil?
          image.image_url = feed_image
          image.save
        end
      end

    end
    categories_status.each do |key, value|
      shop.categories.find_by_id(key).destroy if value == 0
    end

    products_status.each do |key, value|
      shop.products.find_by_id(key).destroy if value == 0
    end

  end

end
