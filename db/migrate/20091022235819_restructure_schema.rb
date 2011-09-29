class RestructureSchema < ActiveRecord::Migration
  def self.up
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :phone, :string
    add_column :orders, :address, :string
    remove_column :orders, :user_id
    remove_column :questions, :user_id
    remove_column :users, :phone
    remove_column :users, :email
    remove_column :users, :address
    change_column :questions, :question, :string, :limit => 80
    change_column :questions, :answer, :string, :limit => 80
  end

  def self.down
    change_column :questions, :question, :string, :limit => 30
    change_column :questions, :answer, :string, :limit => 30
    add_column :users, :phone, :string
    add_column :users, :email, :string
    add_column :users, :address, :string
    add_column :questions, :user_id, :integer
    add_column :orders, :user_id, :integer
    remove_column :orders, :address
    remove_column :orders, :phone
    remove_column :orders, :email
    remove_column :orders, :name
  end
end
