require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should create initial shop" do
    user = User.new :email => "guest@blindoptimists.com",
      :password => "admin123",
      :password_confirmation => "admin123"
    user.roles = ['end']
    assert user.valid?
    user.save
    assert_equal user.shops.size, 1
  end

end
