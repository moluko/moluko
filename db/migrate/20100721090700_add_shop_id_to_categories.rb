class AddShopIdToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :shop_id, :integer
    Category.reset_column_information
    Category.all.each do |category|
      shop = category.user.shops.first
      category.update_attributes :shop_id => shop.id
    end
  end

  def self.down
    remove_column :categories, :shop_id
  end
end
