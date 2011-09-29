class AddShopIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :shop_id, :integer
    Product.reset_column_information
    Product.all.each do |product|
      shop = product.user.shops.first
      product.shop_id = shop.id
      product.save(false)
    end
  end

  def self.down
    remove_column :products, :shop_id
  end
end
