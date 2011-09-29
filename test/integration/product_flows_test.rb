require 'test_helper'

class ProductFlowsTest < ActionController::IntegrationTest
  fixtures :all

  # test "user with import product can't add new product" do
  #   # erase all stand alone products
  #   user = users(:register_user)
  #   user.products.feed_source_equals(0).each do |p|
  #     p.destroy
  #   end

  #   #stand alone products must be zero and only left import product
  #   assert_equal 0, user.products.feed_source_equals(0).size

  #   # fill in login information and expect redirect to products_path
  #   post '/user_sessions', { :user_session => { :email => "abdi@blindoptimists.com", :password => "admin123" }}
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_template 'products/index'

  #   #should redirect when open new product page
  #   get '/products/new'
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_template 'products/index'

  #   #should redirect when post new product
  #   post '/products', { :product => { :title => "test product", :price => "123" }}
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_template 'products/index'

  #   #should success when open import product page
  #   get '/bulk_import'
  #   assert_response :success
  #   assert_template 'bulk_import/index'

  # end

  # test "user with stand alone product can't add import product" do
  #   # erase all import products
  #   user = users(:register_user)
  #   user.products.feed_source_does_not_equal(0).each do |p|
  #     p.destroy
  #   end

  #   #import products must be zero and only left stand alone products
  #   assert_equal 0, user.products.feed_source_does_not_equal(0).size

  #   # fill in login information and expect redirect to products_path
  #   post '/user_sessions', { :user_session => { :email => "abdi@blindoptimists.com", :password => "admin123" }}
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_template 'products/index'

  #   #should redirect when open import page
  #   get '/bulk_import'
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_template 'products/index'

  #   #should success when open new product page
  #   get '/products/new'
  #   assert_response :success
  #   assert_template 'products/new'

  # end

end
