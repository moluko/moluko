class AddKeyValueToSpecification < ActiveRecord::Migration
  def self.up
    add_column :specifications, :key, :string
    add_column :specifications, :value, :string
  end

  def self.down
    remove_column :specifications, :key
    remove_column :specifications, :value
  end
end
