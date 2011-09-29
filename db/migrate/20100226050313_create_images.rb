class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :url_to_image
      t.references :product

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
