class ChangeProductSchema < ActiveRecord::Migration
  def self.up
    add_column :products, :free_shipping, :string, :default => '1'
    add_column :products, :weight, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :products, :enable_buy, :string, :default => '1'
    add_column :products, :enable_visit, :string, :default => '0'
    Product.reset_column_information
    Product.all.each do |product|
      if product.feed_source == 0
        product.enable_buy = '1'
        product.enable_visit = '0'
      else
        product.enable_buy = '0'
        product.enable_visit = '1'
      end
      product.free_shipping = '1'
      product.weight = 0
      product.save
    end
  end

  def self.down
    remove_column :products, :enable_buy
    remove_column :products, :enable_visit
    remove_column :products, :free_shipping
    remove_column :products, :weight
  end
end
