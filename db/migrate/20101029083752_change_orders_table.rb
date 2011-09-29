class ChangeOrdersTable < ActiveRecord::Migration
  def self.up
    add_column :orders, :shipping_fee, :decimal, :precision => 12, :scale => 2
    add_column :orders, :country, :string
    add_column :orders, :region, :string
    add_column :orders, :zipcode, :string
    add_column :orders, :delivery_type, :string
    add_column :orders, :paypal_parameter_id, :integer
    add_column :orders, :fb_id, :integer
  end

  def self.down
    remove_column :orders, :shipping_fee
    remove_column :orders, :country
    remove_column :orders, :region
    remove_column :orders, :zipcode
    remove_column :orders, :delivery_type
    remove_column :orders, :paypal_parameter_id
    remove_column :orders, :fb_id
  end
end
