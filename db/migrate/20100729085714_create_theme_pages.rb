class CreateThemePages < ActiveRecord::Migration
  def self.up
    create_table :theme_pages do |t|
      t.references :theme
      t.string :name
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :theme_pages
  end
end
