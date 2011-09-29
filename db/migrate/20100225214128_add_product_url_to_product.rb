class AddProductUrlToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :url_to_product, :string
  end

  def self.down
    remove_column :products, :url_to_product
  end
end
