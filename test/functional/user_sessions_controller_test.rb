require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should show login form" do
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:user_session)
    assert_select 'input#user_session_email'
    assert_select 'input#user_session_password'
    assert_select 'a[href="/password_resets/new"]', 'Forgot your password?'
    assert_select "a.small-button[onclick=\"$(this).closest('form').submit(); return false;\"]", 'Login'
  end

  test "should perform user login" do
    post :create, {:user_session => { :email => "end@blindoptimists.com", :password => "admin123" }}
    assert_not_nil session[:user_credentials]
    assert_equal session[:user_credentials], users(:end_user).persistence_token
    assert_response :redirect
    assert_redirected_to getstarted_path
  end

  test "should fail user login for unregister user" do
    post :create, :user_session => { :email => "aaa@aaa.com", :password => "admin123" }
    assert_response :success
    assert_template :new
    assert_nil controller.session[:user_credentials]
  end

  test "should fail user login when input blank" do
    post :create
    assert_response :success
    assert_template :new
    assert_nil controller.session[:user_credentials]
    assert_select 'div.info.error', 'You did not provide any details for authentication.'
  end

  test "should fail user login when password blank" do
    post :create, :user_session => { :email => "aaa@aaa.com" }
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', 'Password cannot be blank'
  end

  test "should fail user login when email not found" do
    post :create, :user_session => { :email => "aaa@aaa.com", :password => 'admin123' }
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', 'Email is not valid'
  end

  test "should fail user login when email found but password wrong" do
    post :create, :user_session => { :email => "end@blindoptimists.com", :password => 'admin123456' }
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', 'Password is not valid'
  end

  test "should logout and clear session" do
    UserSession.create(users(:end_user))
    delete :destroy
    assert_response :redirect
    assert_redirected_to root_path
    assert_nil controller.session[:user_credentials]
  end

  test "should redirect after login with return url" do
    path = '/products/new'
    post :create, {:user_session => {:email => "end@blindoptimists.com", :password => "admin123"}}, {'return_to' => path }
    assert_response :redirect
    assert_redirected_to path
  end


end
