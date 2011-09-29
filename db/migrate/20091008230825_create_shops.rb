class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :email
      t.string :contact
      t.string :payment
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
