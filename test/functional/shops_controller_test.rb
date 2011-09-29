require 'test_helper'

class ShopsControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test "should not allow unregister user to view shop page" do
    get :index
    assert_response :redirect
    assert_redirected_to login_path
    get :new
    assert_response :redirect
    assert_redirected_to login_path
    get :edit, { :id => 'current' }
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should show new shop for register user" do
    UserSession.create(users(:end_user))
    get :new
    assert_response :success
    assert_template :new
    assert_select 'input#shop_name'
    assert_select "a.button[onclick=\"$(this).parent().submit();; return false;\"]", 'Save'
    assert_select "a.button[href='/shops']", 'Cancel'
  end

  test "should show shop index for register user" do
    UserSession.create(users(:end_user))
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:shops)
    assert_equal assigns(:shops).size, 2
    assert_select "a.button[href='/shops/new']", '+ Add New Store'
  end

  test "should show shop for register user" do
    UserSession.create(users(:end_user))
    get :show, { :id => 'current' }
    assert_response :redirect
  end

  test "should show edit shop for register user" do
    UserSession.create(users(:end_user))
    get :edit, { :id => 'current' }
    assert_response :success
    assert_template :edit
    assert_select 'input#shop_name'
    assert_select 'textarea#shop_description'
    assert_select 'input#shop_status_1'
    assert_select 'input#shop_status_0'
    assert_select 'input#shop_company_name'
    assert_select 'input#shop_phone'
    assert_select 'input#shop_email'
    assert_select 'select#shop_location'
    assert_select "a.button[onclick=\"$(this).parent().submit();; return false;\"]", 'Save'
  end

  test "should show payment for register user" do
    UserSession.create(users(:end_user))
    get :payment, { :id => 'current' }
    assert_response :success
    assert_template :payment
    assert_select 'input#shop_paypal_email'
    assert_select 'select#shop_paypal_currency'
    assert_select 'option', 22
    assert_select "option[value='TWD']", 'Taiwan New Dollar (NT$)'
    assert_select "option[value='CHF']", 'Swiss Franc (CHF)'
    assert_select "option[value='HKD']", 'Hong Kong Dollar (HK$)'
    assert_select "option[value='PHP']", 'Philippine Peso (₱)'
    assert_select "option[value='NZD']", 'New Zealand Dollar (NZ$)'
    assert_select "option[value='EUR']", 'Euro (€)'
    assert_select "option[value='THB']", 'Thai Baht (฿)'
    assert_select "option[value='SEK']", 'Swedish Krona (kr)'
    assert_select "option[value='MXN']", 'Mexican Peso (Mex$)'
    assert_select "option[value='HUF']", 'Hungarian Forint (Ft)'
    assert_select "option[value='DKK']", 'Danish Krone (kr)'
    assert_select "option[value='SGD']", 'Singapore Dollar (S$)'
    assert_select "option[value='ILS']", 'Israeli New Sheqel (₪)'
    assert_select "option[value='USD']", 'U.S. Dollar (US$)'
    assert_select "option[value='MYR']", 'Malaysian Ringgit (RM)'
    assert_select "option[value='CAD']", 'Canadian Dollar (C$)'
    assert_select "option[value='PLN']", 'Polish Zloty (zł)'
    assert_select "option[value='JPY']", 'Japanese Yen (¥)'
    assert_select "option[value='CZK']", 'Czech Koruna (Kč)'
    assert_select "option[value='AUD']", 'Australian Dollar (AU$)'
    assert_select "option[value='GBP']", 'Pound Sterling (£)'
    assert_select "option[value='NOK']", 'Norwegian Krone (kr)'
    assert_select "a.button[onclick=\"$(this).parent().submit();; return false;\"]", 'Save'
    assert_select 'div.info.success', 0
  end

  test "should update payment for register user" do
    UserSession.create(users(:end_user))
    post :update_payment, { :id => 'current', :shop => { :paypal_currency => 'USD', :paypal_email => 'newfashion@moluko.com' } }
    assert_response :redirect
    assert_redirected_to payment_shop_path(:current)
    assert_equal 'Your payment details has been successfully updated.', flash[:info]
  end

  test "should not update payment for wrong paypal email" do
    UserSession.create(users(:end_user))
    post :update_payment, { :id => 'current', :shop => { :paypal_currency => 'USD', :paypal_email => 'fashion' } }
    assert_response :success
    assert_template :payment
    assert_select 'div.info.error', 'Paypal email is invalid'
  end

end
