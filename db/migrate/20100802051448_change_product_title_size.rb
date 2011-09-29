class ChangeProductTitleSize < ActiveRecord::Migration
  def self.up
    change_column :products, :title, :string
  end

  def self.down
    change_column :products, :title, :string, :limit => 50
  end
end
