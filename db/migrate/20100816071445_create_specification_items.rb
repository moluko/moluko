class CreateSpecificationItems < ActiveRecord::Migration
  def self.up
    create_table :specification_items do |t|
      t.references :specification
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :specification_items
  end
end
