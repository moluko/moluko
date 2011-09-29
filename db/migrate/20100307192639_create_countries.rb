class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.column :iso, :string, :size => 2
      t.column :name, :string, :size => 80
      t.column :printable_name, :string, :size => 80
      t.column :iso3, :string, :size => 3
      t.column :numcode, :integer

      t.timestamps
    end

  end

  def self.down
    drop_table :countries
  end
end
