require 'fastercsv'

class ImportShippingPlansUsingCSVJob < Struct.new(:csv_data, :shop_id)

  def perform

    shop = Shop.find shop_id

    shop.shipping_plans.each do |shipping_plan|
      shipping_plan.destroy
    end

    #checking csv delimiter
    delimiter = csv_data[19,1] == ";" ? ";" : ","

    #iterate csv data
    FasterCSV.parse( csv_data, :headers => true, :col_sep => delimiter, :row_sep => :auto ) do |row|
      #get feed data
      feed_country       = row[0].nil? ? '' : row[0].upcase
      feed_region        = row[1].nil? ? '' : row[1].upcase
      feed_zipcode       = row[2].nil? ? '' : row[2].upcase
      feed_range1        = row[3].nil? ? 0 : row[3]
      feed_range2        = row[4].nil? ? 0 : row[4]
      feed_price         = row[5].nil? ? 0 : row[5]
      feed_delivery_type = row[6].nil? ? '' : row[6].upcase

      shipping_plan = shop.shipping_plans.build :country => feed_country,
        :region => feed_region,
        :zipcode => feed_zipcode,
        :range1 => feed_range1,
        :range2 => feed_range2,
        :price => feed_price,
        :delivery_type => feed_delivery_type
      if shipping_plan.save
      else
      end

    end

  end

end
