class ChangeProductParentToUser < ActiveRecord::Migration
  def self.up
    add_column :products, :user_id, :integer
    Product.all.each do |product|
      shop = Shop.find(product.shop_id)
      product.update_attributes :user_id => shop.user.id
    end
    remove_column :products, :shop_id
  end

  def self.down
    add_column :products, :shop_id, :integer
    Product.all.each do |product|
      product.update_attributes :shop_id => product.user.shops.first.id
    end
    remove_column :products, :user_id
  end
end
