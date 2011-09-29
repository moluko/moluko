require 'test_helper'

class ShippingPlansControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test "should show the index pages for register user" do
    UserSession.create(users(:end_user))
    get :index
    assert_response :success
    assert_template :index
    assert_select "a[href='#{APP_CONFIG[:domain_name]}/shipping_rates_sample.xls']", 'shipping_rates_sample.xls'
    assert_select "a.button[onclick=\"$(this).parent().submit();; return false;\"]", 'Upload'
  end

  test "should not show the index pages for anonymous" do
    get :index
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should create shipping plan for register user" do
    UserSession.create(users(:end_user))
    csv_file = fixture_file_upload('../files/test_shipping_plans.csv', 'text')
    post :create_using_csv, :csv => { :file => csv_file }
    assert_response :redirect
    assert_redirected_to shipping_plans_path
  end

end
