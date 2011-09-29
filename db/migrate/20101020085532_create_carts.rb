class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.references :shop
      t.integer :fb_id
      t.decimal :shipping_fee, :precision => 12, :scale => 2
      t.string :country
      t.string :region
      t.string :zipcode
      t.string :delivery_type

      t.timestamps
    end
  end

  def self.down
    drop_table :carts
  end
end
