class AddGroupToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :group_specification, :string
  end

  def self.down
    remove_column :products, :group_specification
  end
end
