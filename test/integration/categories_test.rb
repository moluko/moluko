require 'test_helper'

class CategoriesTest < ActionController::IntegrationTest
  fixtures :all

  test "goto new category page, redirect to login, create new category, logout" do

    # goto new category page without login and expect redirect to login page
    get '/categories/new'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'user_sessions/new'

    # fill in login information and expect redirect to new category page
    post '/user_sessions', { :user_session => { :email => "end@blindoptimists.com", :password => "admin123" }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'categories/new'

    # fill in new category information and expect redirect to categories index
    post '/categories', { :category => { :name => "Test Category"} }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'categories/index'

    # logout and expect redirect to home
    get '/logout'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'user_sessions/new'

  end
end
