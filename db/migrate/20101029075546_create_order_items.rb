class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.references :order
      t.string :product_title
      t.string :product_sku
      t.integer :product_quantity
      t.decimal :product_price, :precision => 12, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
