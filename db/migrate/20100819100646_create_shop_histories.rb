class CreateShopHistories < ActiveRecord::Migration
  def self.up
    create_table :shop_histories do |t|
      t.references :shop
      t.string :controller
      t.string :action
      t.text :params

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_histories
  end
end
