class ChangeOrderSchema < ActiveRecord::Migration
  def self.up
    remove_column :orders, :customer_name
    remove_column :orders, :customer_email
    remove_column :orders, :customer_address
    remove_column :orders, :customer_phone
    remove_column :orders, :product_title
    remove_column :orders, :product_price
    remove_column :orders, :currency_code
    remove_column :orders, :customer_instruction
    add_column :orders, :item_name, :string
    add_column :orders, :item_price, :decimal, :default => 0, :precision => 8, :scale => 2
    add_column :orders, :quantity, :integer
    add_column :orders, :shipping, :decimal, :default => 0, :precision => 8, :scale => 2
    add_column :orders, :amount, :decimal, :default => 0, :precision => 8, :scale => 2
    add_column :orders, :specifications, :string
    add_column :orders, :address_name, :string
    add_column :orders, :address_street, :string
    add_column :orders, :address_city, :string
    add_column :orders, :address_state, :string
    add_column :orders, :address_zip, :string
    add_column :orders, :address_country, :string
    add_column :orders, :address_country_code, :string
    add_column :orders, :payer_email, :string
    add_column :orders, :mc_currency, :string
    add_column :orders, :memo, :string
    add_column :orders, :shipping_status, :string, :default => "0"
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :position, :string
  end

  def self.down
    add_column :orders, :customer_name, :string
    add_column :orders, :customer_address, :string
    add_column :orders, :customer_phone, :string
    add_column :orders, :customer_email, :string
    add_column :orders, :product_title, :string
    add_column :orders, :product_price, :string
    add_column :orders, :currency_code, :string
    add_column :orders, :customer_instruction, :string
    remove_column :orders, :item_name
    remove_column :orders, :item_price
    remove_column :orders, :quantity
    remove_column :orders, :shipping
    remove_column :orders, :amount
    remove_column :orders, :specifications
    remove_column :orders, :address_name
    remove_column :orders, :address_street
    remove_column :orders, :address_city
    remove_column :orders, :address_state
    remove_column :orders, :address_zip
    remove_column :orders, :address_country
    remove_column :orders, :address_country_code
    remove_column :orders, :payer_email
    remove_column :orders, :mc_currency
    remove_column :orders, :memo
    remove_column :orders, :shipping_status
    remove_column :orders, :first_name
    remove_column :orders, :last_name
    remove_column :orders, :position
  end
end
