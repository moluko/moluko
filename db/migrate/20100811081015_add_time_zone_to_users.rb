class AddTimeZoneToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :string, :default => 'UTC'
    User.reset_column_information
    User.all.each do |user|
      user.update_attributes :time_zone => 'UTC'
    end
  end

  def self.down
    remove_column :users, :time_zone
  end
end
