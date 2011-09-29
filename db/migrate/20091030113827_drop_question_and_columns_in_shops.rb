class DropQuestionAndColumnsInShops < ActiveRecord::Migration
  def self.up
    drop_table :questions
    remove_column :shops, :email
    remove_column :shops, :contact
    remove_column :shops, :payment
    add_column :shops, :paypal, :string
    add_column :shops, :currency_code, :string
  end

  def self.down
    remove_column :shops, :currency_code
    remove_column :shops, :paypal
    add_column :shops, :payment, :string
    add_column :shops, :contact, :string
    add_column :shops, :email, :string

    create_table :questions do |t|
      t.string :question, :limit => APP_CONFIG[:question_max]
      t.string :answer, :limit => APP_CONFIG[:question_max]
      t.references :user
      t.references :product
      t.timestamps
    end

  end
end
