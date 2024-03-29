class CreateCartItems < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.references :cart
      t.references :product
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :cart_items
  end
end
