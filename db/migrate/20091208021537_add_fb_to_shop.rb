class AddFbToShop < ActiveRecord::Migration
  def self.up
    add_column :shops, :fb_page_id, :integer
    add_column :shops, :fb_session_key, :string
    #for mysql only, comment it for sqlite3
    #execute("alter table shops modify fb_page_id bigint")
  end

  def self.down
    remove_column :shops, :fb_session_key
    remove_column :shops, :fb_page_id
  end
end
