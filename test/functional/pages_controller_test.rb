require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should not show dashboard for non admin" do
    UserSession.create(users(:end_user))
    get :dashboard
    assert_response :missing
  end

  test "should show get started for subscribe user" do
    UserSession.create(users(:end_user))
    get :getstarted
    assert_response :success
    assert_template :getstarted
    assert_select "a[href='/getstarted']", 'Get Started'
    assert_select "a[href='/shops/current/edit']", 'Profile'
    assert_select "a[href='/shops/current/edit']", 'Profile'
    assert_select "a[href='/products']", 'Product'
    assert_select "a[href='/categories']", 'Category'
    assert_select "a[href='/shops/current/themes']", 'Theme'
    assert_select "a[href='/sales']", 'Sales'
    assert_select "a[href='/shipping_plans']", 'Shipping Rates'
    assert_select "a[href='/shops/current/payment']", 'Payment'
    assert_select "a[href='/users/current/edit']", 'End'
    assert_select "a[href='/shops']", 'Admin'
    assert_select "a[href='/logout']", 'Logout'
    assert_select "a[href='/dashboard']", 0
    assert_select "a[href='/themes']", 0
    assert_select "a[href='/subscription_plans']", 0
    assert_select "a[href='/all_user_histories']", 0
    assert_select "a[href='/all_shop_histories']", 0
    assert_select "a[href='/countries']", 0
  end

  test "should show dashboard for admin" do
    UserSession.create(users(:admin_user))
    get :dashboard
    assert_response :success
    assert_template :dashboard
    assert_select "a[href='/dashboard']", 'Dashboard'
  end

end
