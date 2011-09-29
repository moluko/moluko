class AddShopActivationKeyToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :shop_activation_key, :string
  end

  def self.down
    remove_column :users, :shop_activation_key
  end
end
