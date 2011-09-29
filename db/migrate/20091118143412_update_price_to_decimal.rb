class UpdatePriceToDecimal < ActiveRecord::Migration
  def self.up
    remove_column :products, :price
    add_column :products, :price, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    add_column :products, :price, :string, :limit => 50
  end
end
