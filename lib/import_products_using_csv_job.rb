require 'fastercsv'

class ImportProductsUsingCSVJob < Struct.new(:csv_data, :delimiter, :shop_id)

  def perform
    shop = Shop.find shop_id

    #erase old data
    shop.products.each {|product| product.destroy }
    shop.categories.each {|category| category.destroy }

    begin
      #iterate csv data
      FasterCSV.parse( csv_data, :headers => true, :col_sep => delimiter, :row_sep => :auto ) do |row|
        par = {}
        par[:images_attributes] = []
        par[:specifications_attributes] = []
        row.each do |field|
          field[1] = '' if field[1].nil?
          case field[0].upcase
          when 'TITLE' then par[:title] = field[1].to_s
          when 'PRICE' then par[:price] = field[1].to_f
          when 'DESCRIPTION' then par[:description] = field[1]
          when 'WEIGHT' then par[:weight] = field[1].to_f
          when 'SKU' then par[:sku] = field[1]
          when 'GROUPBY' then par[:group_specification] = field[1]
          when 'VISITURL' then par[:url_to_product] = field[1]
          when 'ENABLEBUYBUTTON'
            case field[1].upcase
            when 'YES' then par[:enable_buy] = '1'
            when 'NO' then par[:enable_buy] = '0'
            else
              par[:enable_buy] = '1'
            end
          when 'ENABLEVISITBUTTON'
            case field[1].upcase
            when 'YES' then par[:enable_visit] = '1'
            when 'NO' then par[:enable_visit] = '0'
            else
              par[:enable_visit] = '0'
            end
          when 'FREESHIPPING'
            case field[1].upcase
            when 'YES' then par[:free_shipping] = '1'
            when 'NO' then par[:free_shipping] = '0'
            else
              par[:free_shipping] = '1'
            end
          when 'DISCOUNTEDPRICE'
            if field[1].to_f > 0
              par[:discount_status] = '1'
              par[:discount_price] = field[1].to_f
            end
          when 'CATEGORY'
            category = shop.categories.find_by_name field[1]
            category = shop.categories.build if category.nil?
            category.name = field[1]
            category.save
            par[:category_id] = category.id
          when 'IMAGEURL'
            par[:images_attributes] << { :image_url => field[1] } unless field[1].blank?
          else #for specification
            unless field[1].blank?
              par[:specifications_attributes] << { :key => field[0], :value => field[1] }
            end
          end
        end
        product = shop.products.build par
        product.save
      end
    rescue
    end
  end

end
