require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  test "should not create shop without name" do
    shop = Shop.new
    assert !shop.valid?
  end

  test "should create shop with name" do
    shop = Shop.new
    shop.name = "My Store"
    assert shop.valid?
  end

# test "should create trial" do
#   shop = create_shop
#   shop.create_trial
#   assert_equal shop.subscription_plan_id, 0
#   assert_equal shop.name, "My Store"
#   assert_nil shop.subscription_id
#   assert_equal shop.subscription_end, shop.subscription_start + 7.days
# end

# test "should create subscription" do
#   shop = create_shop
#   plan_id = 1
#   subscription_id = '123'
#   shop.create_subscription plan_id, subscription_id
#   assert_equal shop.subscription_plan_id, plan_id
#   assert_equal shop.subscription_id, subscription_id
#   assert_equal shop.subscription_end, shop.subscription_start + 1.months + 7.days
# end

# test "should update subscription" do
#   shop = create_shop
#   plan_id = 1
#   subscription_id = '123'
#   shop.create_subscription plan_id, subscription_id
#   shop.update_subscription
#   assert_equal shop.subscription_end, shop.subscription_start + 1.months + 7.days
# end

# test "should cancel subscription" do
#   shop = create_shop
#   plan_id = 1
#   subscription_id = '123'
#   shop.create_subscription plan_id, subscription_id
#   shop.cancel_subscription
#   assert_nil shop.subscription_plan_id
#   assert_nil shop.subscription_id
# end

# test "should create blank subscription" do
#   shop = create_shop
#   shop.create_blank_subscription
#   assert_nil shop.subscription_plan_id
#   assert_nil shop.subscription_id
# end

  private

  def create_shop
    shop = Shop.new
    shop.name = "My Store"
    shop.save
    shop
  end

end
