class RemoveFbFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :facebook_id
    remove_column :users, :facebook_session_key
  end

  def self.down
    add_column :users, :facebook_id, :integer
    add_column :users, :facebook_session_key, :string
    #for mysql only, comment it for sqlite3
    #execute("alter table users modify facebook_id bigint")
  end
end
