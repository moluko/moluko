require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

  test "should show new" do
    get :new
    assert_response :success
    assert_template :new
    assert_select 'input#email'
    assert_select "a.small-button[onclick=\"$(this).closest('form').submit(); return false;\"]", 'Reset'
  end

  test "should create perishable token" do
    post :create, :email => "end@blindoptimists.com"
    assert_response :success
    assert_template :new
    assert_select 'div.info.success', 'Instructions to reset your password have been emailed to you. Please check your email.'
  end

  test "should not create perishable token if email not found" do
    post :create, :email => "aaa@bbb.com"
    assert_response :success
    assert_template :new
    assert_select 'div.info.error', 'No user was found with that email address'
  end

  test "should show change password form" do
    get :edit, :id => users(:end_user).perishable_token
    assert_response :success
    assert_template :edit
    assert_select 'input#user_password'
    assert_select 'input#user_password_confirmation'
    assert_select "a.small-button[onclick=\"$(this).closest('form').submit(); return false;\"]", 'Update'
  end

  test "should not show change password form for uknown perishable taken" do
    get :edit, :id => "xxx"
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should change password" do
    post :update, { :id => users(:end_user).perishable_token, :user => { :password => "admin123", :password_confirmation => "admin123" } }
    assert_response :redirect
    assert_redirected_to products_path
  end

  test "should not change password for invalid data" do
    post :update, { :id => users(:end_user).perishable_token, :user => { :password => "admin123", :password_confirmation => "admin123x" } }
    assert_response :success
    assert_template :edit
  end

end
