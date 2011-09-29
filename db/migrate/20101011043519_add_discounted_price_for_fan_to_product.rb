class AddDiscountedPriceForFanToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :discount_for_fan_status, :string, :default => '0'
    Product.all.each do |product|
      product.update_attributes :discount_for_fan_status => '0'
    end
  end

  def self.down
    remove_column :products, :discount_for_fan_status
  end
end
