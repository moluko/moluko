class AddBigCommerceFeedLinkToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :big_commerce_feed_link, :string
  end

  def self.down
    remove_column :shops, :big_commerce_feed_link
  end
end
