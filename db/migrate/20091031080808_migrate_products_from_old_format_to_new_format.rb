class MigrateProductsFromOldFormatToNewFormat < ActiveRecord::Migration
  def self.up
    add_column :products, :shop_id, :integer
    Product.all.each do |product|
      product.shop_id = product.user.shop.id
      product.save
    end
    remove_column :products, :user_id
  end

  def self.down
    add_column :products, :user_id, :integer
    Product.all.each do |product|
      product.user_id = product.shop.user.id
      product.save
    end
    remove_column :products, :shop_id
  end
end
