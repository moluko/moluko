class AddThemeToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :theme_id, :integer
  end

  def self.down
    remove_column :shops, :theme_id
  end
end
