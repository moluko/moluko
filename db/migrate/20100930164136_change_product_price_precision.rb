class ChangeProductPricePrecision < ActiveRecord::Migration
  def self.up
    change_column :products, :price, :decimal, :precision => 12, :scale => 2, :default => 0
    change_column :products, :discount_price, :decimal, :precision => 12, :scale => 2, :default => 0
  end

  def self.down
    change_column :products, :price, :decimal, :precision => 8, :scale => 2, :default => 0
    change_column :products, :discount_price, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
