class ChangeCategoryParentToUser < ActiveRecord::Migration
  def self.up
    add_column :categories, :user_id, :integer
    Category.all.each do |category|
      shop = Shop.find(category.shop_id)
      category.update_attributes :user_id => shop.user.id
    end
    remove_column :categories, :shop_id
  end

  def self.down
    add_column :categories, :user_id, :integer
    Category.all.each do |category|
      category.update_attributes :shop_id => category.user.shops.first.id
    end
    remove_column :categories, :user_id
  end
end
