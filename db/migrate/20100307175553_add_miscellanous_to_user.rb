class AddMiscellanousToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :company_name, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :country, :string
    add_column :users, :currency_symbol, :string
  end

  def self.down
    remove_column :users, :currency_symbol
    remove_column :users, :country
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :company_name
  end
end
