class ChangeShopAndProductLimitation < ActiveRecord::Migration
  def self.up
    change_column :products, :description, :text
    change_column :shops, :shipping, :text
    change_column :shops, :return, :text
  end

  def self.down
    change_column :shops, :return, :string
    change_column :shops, :shipping, :string
    change_column :products, :description, :string
  end
end
