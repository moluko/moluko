require 'test_helper'

class UserFlowsTest < ActionController::IntegrationTest

  test "general user flow from start till end" do

    #===========================
    #test public page
    #===========================

    # anonymous browse home page
    get '/'
    assert_response :success
    assert_template root_path

    # anonymous browse login page
    get '/login'
    assert_response :success
    assert_template 'user_sessions/new'

    #===========================
    #test user page
    #===========================

    # create end user
    email = 'admin@admin.com'
    password = 'admin'
    User.create :email => email, :password => password, :password_confirmation => password

    #end user login to moluko
    post '/user_sessions', :user_session => { :email => email, :password => password }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'pages/getstarted'

    # signup user browse get started page
    get '/getstarted'
    assert_response :success
    assert_template 'pages/getstarted'

    # signup user browse store profile page
    get "/shops/current"
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'shops/edit'

    # signup user browse edit store profile page
    get "/shops/current/edit"
    assert_response :success
    assert_template 'shops/edit'

    # signup user update store profile page
    put "/shops/current", { :shop => { :name => "1st Store", :description => "Finest store in the world", :company_name => "moluko", :phone => "12345", :email => "xxx@yyy.com" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'shops/edit'

    # signup user browse products page
    get '/products'
    assert_response :success
    assert_template 'products/index'

    # signup user add new product page
    get '/products/new'
    assert_response :success
    assert_template 'products/new'

    # signup user create new product
    post '/products', { :product => { :title => "Sponge Bob T-Shirt", :price => "22" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'products/index'

    # signup user create new product
    post '/products', { :product => { :title => "Sponge Bob Hat", :price => "11" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'products/index'

    #store created product
    product = assigns['products'].first

    # signup user browse categories page
    get '/categories'
    assert_response :success
    assert_template 'categories/index'

    # signup user add new category page
    get '/categories/new'
    assert_response :success
    assert_template 'categories/new'

    # signup user create new category
    post '/categories', { :category => { :name => "T-Shirt" }}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'categories/index'

    #store created category
    category = assigns['categories'].first

    # signup user browse products page
    get '/products'
    assert_response :success
    assert_template 'products/index'

    # signup user edit product page
    get "/products/#{product.id}/edit"
    assert_response :success
    assert_template 'products/edit'

    # signup user update previous product add category
    put "/products/#{product.id}", { :product => { :title => "Sponge Bob T-Shirt", :price => "22", :category_id => category.id } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'products/index'

    # signup user browse themes page
    get "/shops/current/themes"
    assert_response :success
    assert_template 'shops/themes'

    # signup user browse sales page
    get "/sales"
    assert_response :success
    assert_template 'sales/index'

    # signup user browse shipping plans page
    get "/shipping_plans"
    assert_response :success
    assert_template 'shipping_plans/index'

    # signup user create shipping plans
    csv_file = fixture_file_upload('../files/test_shipping_plans.csv', 'text')
    post "/shipping_plans/create_using_csv", :csv => { :file => csv_file }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'shipping_plans/index'
    assert_equal 21, assigns(:shipping_plans).size
    shipping_plans = assigns(:shipping_plans)

    # signup user destroy the last shipping plan
    delete "/shipping_plans/#{shipping_plans.last.id}"
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'shipping_plans/index'
    assert_equal 20, assigns(:shipping_plans).size

    # signup user browse payment page
    get "/shops/current/payment"
    assert_response :success
    assert_template 'shops/payment'

    # signup user browse edit user profile page
    get "/users/current/edit"
    assert_response :success
    assert_template 'users/edit'

    # signup user browse user profile page will redirect to edit
    get "/users/current"
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'users/edit'

    # signup user browse shop index page
    get '/shops'
    assert_response :success
    assert_template 'shops/index'

    # signup user browse new shop page
    get '/shops/new'
    assert_response :success
    assert_template 'shops/new'

    # signup user try create shop with blank name
    post '/shops', { :shop => { :name => '' } }
    assert_response :success
    assert_template 'shops/new'

    # signup user browse new shop page
    post '/shops', { :shop => { :name => '2nd Store' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'shops/index'

    second_shop = assigns['shops'].last
    first_shop = assigns['shops'].first
    assert_equal second_shop.position, 2

    # signup user switch to 2nd store
    get "/shops/#{second_shop.id}/switch_shop"
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'shops/edit'
    assert_equal assigns['current_shop'].position, 1

    # logout
    get "/logout"
    assert_response :redirect
    follow_redirect!
    assert_response :success

    #go to login page
    get '/login'
    assert_response :success
    assert_template 'user_sessions/new'

    #user login again to moluko
    post '/user_sessions', :user_session => { :email => email, :password => password }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template 'pages/getstarted'

  end

  test "test should not allow moluko admin pages for signup user" do
    # anonymous try to signup new user
    post '/users', { :user => { :email => "abdi@moluko.com", :password => "admin123", :password_confirmation => "admin123" }}
    assert_response :redirect
    follow_redirect!
    assert_template 'user_sessions/new'

    # create end user
    email = 'admin@admin.com'
    password = 'admin'
    User.create :email => email, :password => password, :password_confirmation => password

    #end user login to moluko
    post '/user_sessions', :user_session => { :email => email, :password => password }

    #admin dashboard
    get '/dashboard'
    assert_response :missing

    #admin themes
    get '/themes'
    assert_response :missing

    #admin all user histories
    get '/all_user_histories'
    assert_response :missing

    #admin all shop histories
    get '/all_shop_histories'
    assert_response :missing

    #admin countries
    get '/countries'
    assert_response :missing
  end

end
