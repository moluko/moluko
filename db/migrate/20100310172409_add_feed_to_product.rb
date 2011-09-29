class AddFeedToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :feed_id, :string
    add_column :products, :feed_source, :integer
    Product.all.each do |p|
      p.update_attributes( :feed_source => 0 )
    end
  end

  def self.down
    remove_column :products, :feed_source
    remove_column :products, :feed_id
  end
end
