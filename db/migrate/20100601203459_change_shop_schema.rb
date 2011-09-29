class ChangeShopSchema < ActiveRecord::Migration
  def self.up
    add_column :shops, :company_name, :string
    add_column :shops, :description, :text
    add_column :shops, :phone, :string
    add_column :shops, :email, :string
    add_column :shops, :location, :string
    add_column :shops, :activation_key, :string
    add_column :shops, :position, :integer
    add_column :shops, :name, :string
    add_column :shops, :paypal_email, :string
    add_column :shops, :paypal_currency, :string, :default => "USD"
    Shop.reset_column_information
    Shop.all.each do |shop|
      user = shop.user
      shop.update_attributes :paypal_email => user.paypal_email,
        :paypal_currency => user.currency_symbol,
        :name => "My Store",
        :activation_key => user.shop_activation_key
    end
    User.all.each do |user|
      user.create_initial_shop if user.shops.size == 0
    end
  end

  def self.down
    remove_column :shops, :company_name
    remove_column :shops, :description
    remove_column :shops, :phone
    remove_column :shops, :email
    remove_column :shops, :location
    remove_column :shops, :activation_key
    remove_column :shops, :position
    remove_column :shops, :name
    remove_column :shops, :paypal_currency
    remove_column :shops, :paypal_email
  end
end
