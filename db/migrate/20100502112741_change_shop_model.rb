class ChangeShopModel < ActiveRecord::Migration
  def self.up
    add_column :shops, :fb_id, :integer
    add_column :shops, :fb_type, :integer
    change_column :shops, :status, :integer, :default => 1
  end

  def self.down
    remove_column :shops, :fb_id
    remove_column :shops, :fb_type
    change_column :shops, :status, :integer, :default => 0
  end
end
