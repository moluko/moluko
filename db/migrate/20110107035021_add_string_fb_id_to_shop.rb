class AddStringFbIdToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :fb_ids, :string
    add_column :carts, :fb_ids, :string
    add_column :orders, :fb_ids, :string

    Shop.all.each do |shop|
      shop.fb_ids = shop.fb_id.to_s
      shop.save
    end

    Cart.all.each do |cart|
      cart.fb_ids = cart.fb_id.to_s
      cart.save
    end

    Order.all.each do |order|
      order.fb_ids = order.fb_id.to_s
      order.save
    end
  end

  def self.down
    remove_column :shops, :fb_ids
    remove_column :carts, :fb_ids
    remove_column :orders, :fb_ids
  end
end
