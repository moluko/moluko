class ChangeUserModel < ActiveRecord::Migration
  def self.up
    add_column :users, :big_commerce_feed_link, :string
    add_column :users, :shopify_feed_link, :string
  end

  def self.down
    remove_column :users, :big_commerce_feed_link
    remove_column :users, :shopify_feed_link
  end
end
