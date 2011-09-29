class AddFanToShopLogs < ActiveRecord::Migration
  def self.up
    add_column :shop_logs, :fan, :integer
  end

  def self.down
    remove_column :shop_logs, :fan
  end
end
