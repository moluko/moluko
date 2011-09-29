class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.integer :facebook_id
      t.string :facebook_session_key
      t.string :phone
      t.string :email
      t.string :address

      t.timestamps
    end
    #for mysql only, comment it for sqlite3
    #execute("alter table users modify facebook_id bigint")
  end

  def self.down
    drop_table "users"
  end
end
