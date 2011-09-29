class CreatePaypalParameters < ActiveRecord::Migration
  def self.up
    create_table :paypal_parameters do |t|
      t.text :parameters

      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_parameters
  end
end
