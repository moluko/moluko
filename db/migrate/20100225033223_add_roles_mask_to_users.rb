class AddRolesMaskToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :roles_mask, :integer
    User.all.each do |u|
      u.roles = ["shop_owner"]
      u.save(false)
    end
  end

  def self.down
    remove_column :users, :roles_mask
  end
end
