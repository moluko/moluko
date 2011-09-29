class CreateShopLogs < ActiveRecord::Migration
  def self.up
    create_table :shop_logs do |t|
      t.references :shop
      t.integer :facebook_id, :default => nil
      t.integer :product_id, :default => nil
      t.timestamps
    end

    #for mysql only, comment it for sqlite3
    #execute("alter table users modify facebook_id bigint")
  end

  def self.down
    drop_table :shop_logs
  end
end
