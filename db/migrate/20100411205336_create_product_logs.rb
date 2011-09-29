class CreateProductLogs < ActiveRecord::Migration
  def self.up
    create_table :product_logs do |t|
      t.references :product
      t.integer :click_for

      t.timestamps
    end
  end

  def self.down
    drop_table :product_logs
  end
end
