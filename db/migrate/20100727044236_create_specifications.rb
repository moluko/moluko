class CreateSpecifications < ActiveRecord::Migration
  def self.up
    create_table :specifications do |t|
      t.references :product
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :specifications
  end
end
