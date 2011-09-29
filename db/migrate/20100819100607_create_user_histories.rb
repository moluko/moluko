class CreateUserHistories < ActiveRecord::Migration
  def self.up
    create_table :user_histories do |t|
      t.string :remote_ip
      t.string :controller
      t.string :action
      t.text :params
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :user_histories
  end
end
