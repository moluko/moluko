class AddShopifyFeedLinkToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :shopify_feed_link, :string
  end

  def self.down
    remove_column :shops, :shopify_feed_link
  end
end
