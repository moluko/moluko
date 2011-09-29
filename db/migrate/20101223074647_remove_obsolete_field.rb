class RemoveObsoleteField < ActiveRecord::Migration
  def self.up
    #remove users table field
    remove_column :users, :shop_activation_key
    remove_column :users, :plan
    remove_column :users, :subscr_id
    remove_column :users, :subscr_start
    remove_column :users, :subscr_end
    remove_column :users, :company_name
    remove_column :users, :currency_symbol
    remove_column :users, :paypal_email
    remove_column :users, :big_commerce_feed_link
    remove_column :users, :shopify_feed_link
    #remove shops table field
    remove_column :shops, :paypal
    remove_column :shops, :currency_code
    remove_column :shops, :other_payment
    remove_column :shops, :shipping
    remove_column :shops, :return
    remove_column :shops, :fb_page_id
    remove_column :shops, :big_commerce_feed_link
    #drop table facebook_templates and photos
    drop_table :facebook_templates
    drop_table :photos
  end

  def self.down
    add_column :users, :shop_activation_key, :string
    add_column :users, :plan, :integer
    add_column :users, :subscr_id, :string
    add_column :users, :subscr_start, :datetime
    add_column :users, :subscr_end, :datetime
    add_column :users, :company_name, :string
    add_column :users, :currency_symbol, :string
    add_column :users, :paypal_email, :string
    add_column :users, :big_commerce_feed_link, :string
    add_column :users, :shopify_feed_link, :string
    add_column :shops, :paypal, :string
    add_column :shops, :currency_code, :string
    add_column :shops, :other_payment, :string
    add_column :shops, :shipping, :string
    add_column :shops, :return, :string
    add_column :shops, :fb_page_id, :integer
    add_column :shops, :big_commerce_feed_link, :string
    create_table :facebook_templates, :force => true do |t|
      t.string :template_name, :null => false
      t.string :content_hash, :null => false
      t.string :bundle_id, :null => true
    end
    add_index :facebook_templates, :template_name, :unique => true
    create_table :photos do |t|
      t.references :product
      t.timestamps
    end
    add_index :photos, :product_id
  end
end
