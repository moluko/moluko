class AddPlanToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :plan, :integer, :default => 0
    add_column :users, :subscr_id, :string
    add_column :users, :subscr_start, :datetime
    add_column :users, :subscr_end, :datetime
    User.all.each do |user|
      user.update_attributes(:plan => 0)
    end
  end

  def self.down
    remove_column :users, :subscr_id
    remove_column :users, :subscr_start
    remove_column :users, :subscr_end
    remove_column :users, :plan
  end
end
