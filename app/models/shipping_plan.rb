class ShippingPlan < ActiveRecord::Base
  belongs_to :shop

  def country_name
    if self.country == "*"
      "World Wide"
    else
      c  = Country.find_by_iso3(self.country)
      c.nil? ? self.country : c.printable_name
    end
  end

  def region_name
    if self.region == "*"
      "All Region"
    else
      self.region
    end
  end

  def zipcode_name
    if self.zipcode == "*"
      "All Zip Code"
    else
      self.zipcode
    end
  end

end
