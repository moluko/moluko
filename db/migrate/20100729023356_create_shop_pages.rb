class CreateShopPages < ActiveRecord::Migration
  def self.up
    create_table :shop_pages do |t|
      t.references :shop
      t.string :name
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_pages
  end
end
