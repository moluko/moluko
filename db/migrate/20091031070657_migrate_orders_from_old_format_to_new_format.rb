class MigrateOrdersFromOldFormatToNewFormat < ActiveRecord::Migration
  def self.up
    add_column :orders, :shop_id, :integer
    add_column :orders, :product_title, :string
    add_column :orders, :product_price, :string
    add_column :orders, :currency_code, :string
    add_column :orders, :status, :integer, :default => APP_CONFIG[:order_pending]
    rename_column :orders, :name, :customer_name
    rename_column :orders, :email, :customer_email
    rename_column :orders, :phone, :customer_phone
    rename_column :orders, :address, :customer_address
    # port the product_id into product_title, product_price, and remove product_id
    Order.all.each do |order|
      order.product_title = order.product.title
      order.product_price = order.product.price
      order.save
    end
    remove_column :orders, :product_id
  end

  def self.down
    add_column :orders, :product_id, :integer
    # port back the product_id base on product_title and product_price
    Order.all.each do |order|
      product = Product.find_by_title(order.product_title)
      if product.price == order.product_price
        order.product_id = product.id
        order.save
      end
    end
    rename_column :orders, :customer_address, :address
    rename_column :orders, :customer_phone, :phone
    rename_column :orders, :customer_email, :email
    rename_column :orders, :customer_name, :name
    remove_column :orders, :status
    remove_column :orders, :currency_code
    remove_column :orders, :product_price
    remove_column :orders, :product_title
    remove_column :orders, :shop_id
  end
end
