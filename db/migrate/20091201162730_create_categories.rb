class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.references :shop

      t.timestamps
    end
    #add column category to product
    add_column :products, :category_id, :integer, :default => 0
    #update category value to 0 for uncategorized
    Product.all.each do |product|
      product.update_attributes(:category_id => 0)
    end
  end

  def self.down
    remove_column :products, :category_id
    drop_table :categories
  end
end
