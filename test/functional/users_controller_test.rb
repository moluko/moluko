require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup :activate_authlogic

  test "should show new user form for admin user only" do
    UserSession.create(users(:admin_user))
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:user)
    assert_select 'input#user_email'
    assert_select 'input#user_password'
    assert_select 'input#user_password_confirmation'
    assert_select 'div.info.error', 0
  end

  test "should not show new user form for register user" do
    UserSession.create(users(:end_user))
    get :new
    assert_response :missing
  end

  test "should not show user data for unregister user" do
    get :show, :id => users(:end_user).id
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should redirect to edit when show user data for register user" do
    UserSession.create(users(:end_user))
    get :show, :id => users(:end_user).id
    assert_response :redirect
    assert_redirected_to edit_user_path(users(:end_user))
  end

  test "should show edit user form for register user" do
    UserSession.create(users(:end_user))
    get :edit, :id => users(:end_user).id
    assert_response :success
    assert_template :edit
  end

  test "should not show edit user form for unregister user" do
    get :edit, :id => users(:end_user).id
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should create new user" do
    UserSession.create(users(:admin_user))
    post :create, { :user => { :email => "new@user.com", :password => "admin123", :password_confirmation => "admin123" }}
    assert_response :redirect
    assert_redirected_to users_path
  end

  test "should not create new user when password is blank" do
    UserSession.create(users(:admin_user))
    post :create, { :user => { :email => "aaa@aaa.com" }}
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', 'Password is too short (minimum is 4 characters)'
  end

  test "should not create new user when password confirmation is blank" do
    UserSession.create(users(:admin_user))
    post :create, :user => { :email => "aaa@aaa.com", :password => "admin123456" }
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', 'Password confirmation is too short (minimum is 4 characters)'
  end

  test "should not create new user when password does not match" do
    UserSession.create(users(:admin_user))
    post :create, :user => { :email => "aaa@aaa.com", :password => "admin123456", :password_confirmation => 'admin123' }
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', "Password doesn't match confirmation"
  end

end
