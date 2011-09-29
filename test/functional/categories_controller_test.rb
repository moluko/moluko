require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should show new category form for register user" do
    UserSession.create(users(:end_user))
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:category)
    assert assigns(:category).new_record?
    assert_select 'input#category_name'
    assert_select "a.button[onclick=\"$(this).closest('form').submit();; return false;\"]", 'Save'
    assert_select "a.button[href='/categories']", 'Cancel'
  end

  test "should show edit category form for register user" do
    UserSession.create(users(:end_user))
    get :edit, :id => categories(:tshirt_category)
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:category)
    assert !assigns(:category).new_record?
    assert_select 'input#category_name'
    assert_select "a.button[onclick=\"$(this).closest('form').submit();; return false;\"]", 'Save'
    assert_select "a.button[href='/categories']", 'Cancel'
  end

  test "should show categories for register user" do
    UserSession.create(users(:end_user))
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:categories)
    assert_equal 4, assigns(:categories).size
    assert_select "a.button[href='/categories/new']", '+ Add New Category'
  end

  test "should create category for register user" do
    UserSession.create(users(:end_user))
    post :create, :category => { :name => "Gundam" }
    assert_response :redirect
    assert_redirected_to categories_path
  end

  test "should not create category without name" do
    UserSession.create(users(:end_user))
    post :create, :category => { :name => "" }
    assert_response :success
    assert_template :new
  end

  test "should destroy category for register user" do
    UserSession.create(users(:end_user))
    delete :destroy, :id => categories(:tshirt_category).id
    assert_response :redirect
    assert_redirected_to categories_path
  end

end
