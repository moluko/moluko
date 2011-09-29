class ChangeProductFeedSourceDefaultValue < ActiveRecord::Migration
  def self.up
    change_column :products, :feed_source, :integer, :default => 0
  end

  def self.down
    change_column :products, :feed_source, :integer, :default => nil
  end
end
