class CreateShippingPlans < ActiveRecord::Migration
  def self.up
    create_table :shipping_plans do |t|
      t.references :shop
      t.string :country
      t.string :region
      t.string :zipcode
      t.decimal :range1, :precision => 8, :scale => 2, :default => 0
      t.decimal :range2, :precision => 8, :scale => 2, :default => 0
      t.decimal :price, :precision => 8, :scale => 2, :default => 0
      t.string :delivery_type

      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_plans
  end
end
