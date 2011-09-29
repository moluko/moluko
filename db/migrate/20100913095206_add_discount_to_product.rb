class AddDiscountToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :discount_status, :string, :default => '0'
    add_column :products, :discount_price, :decimal, :precision => 8, :scale => 2, :default => 0
    Product.all.each do |product|
      product.update_attributes :discount_status => '0',
        :discount_price => 0
    end
  end

  def self.down
    remove_column :products, :discount_status
    remove_column :products, :discount_price
  end
end
