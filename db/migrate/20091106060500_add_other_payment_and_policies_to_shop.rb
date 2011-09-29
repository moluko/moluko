class AddOtherPaymentAndPoliciesToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :other_payment, :string
    add_column :shops, :shipping, :string
    add_column :shops, :return, :string
  end

  def self.down
    remove_column :shops, :other_payment
    remove_column :shops, :shipping
    remove_column :shops, :return
  end
end
