class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title, :limit => 50
      t.string :description, :limit => 300
      t.string :price, :limit => 50
      t.integer :status, :default => APP_CONFIG[:active_id]
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
