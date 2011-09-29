class OrderAddTxnidChangeStatusTostring < ActiveRecord::Migration
  def self.up
    add_column :orders, :txn_id, :string
	add_column :orders, :payment_status, :string
	remove_column :orders, :status
  end

  def self.down
    remove_column :orders, :txn_id
	remove_column :orders, :payment_status
	add_column :orders, :status, :integer, :default => APP_CONFIG[:order_pending]
  end
end
