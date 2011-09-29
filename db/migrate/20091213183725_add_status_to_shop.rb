class AddStatusToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :status, :integer, :default => 0
    Shop.all.each do |shop|
      shop.update_attributes(:status => 0)
    end
  end

  def self.down
    remove_column :shops, :status
  end
end
