require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  setup :initialize_register_user

  test "should show new product form for register user" do
    UserSession.create(users(:end_user))
    get :new
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:product)
    assert_not_nil assigns(:categories)
    assert assigns(:product).new_record?
    assert_equal assigns(:categories).size, 4
    assert_select 'input#product_title'
    assert_select 'textarea#product_description'
    assert_select 'input#product_weight'
    assert_select 'input#product_price'
    assert_select 'input#product_discount_status'
    assert_select 'input#product_discount_price'
    assert_select 'input#product_sku'
    assert_select 'input#product_free_shipping_1'
    assert_select 'input#product_free_shipping_0'
    assert_select 'input#product_enable_buy_1'
    assert_select 'input#product_enable_buy_0'
    assert_select 'input#product_enable_visit_1'
    assert_select 'input#product_enable_visit_0'
    assert_select "a.button[onclick=\"$(this).closest('form').submit(); return false;\"]", 'Save'
    assert_select "a.button[href='/products']", 'Cancel'
  end

  test "should show edit product form" do
    UserSession.create(users(:end_user))
    get :edit, :id => products(:wrangler_blue_product).id
    assert_not_nil assigns(:product)
    assert_not_nil assigns(:categories)
    assert !assigns(:product).new_record?
    assert_equal assigns(:product), products(:wrangler_blue_product)
    assert_equal 4, assigns(:categories).size
  end

  test "should redirect to products if product nil" do
    UserSession.create(users(:end_user))
    get :edit, :id => 1234
    assert_response :redirect
    assert_redirected_to products_path
  end

  test "should show products for register user" do
    UserSession.create(users(:end_user))
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:products)
    assert_equal 3, assigns(:products).size
    assert_select "a.button[href='/products/new']", '+ Add New Product'
    #assert_select "a.button[href='/bulk_import']", 'Import Product(s)'
  end

  test "should create product without photo for register user" do
    UserSession.create(users(:end_user))
    post :create, :product => { :title => "PG OO Raiser", :price => "3500000" }
    assert_response :redirect
    assert_redirected_to products_path
  end

  test "should create product with minimal data for register user" do
    #  Parameters: {"commit"=>"Simpan", "action"=>"update", "_method"=>"put", "authenticity_token"=>"JiHZkn7gVgyTw79hxdU8Dh3fzAbQWIMTb2nJnmAmEl8=", "id"=>"2", "product"=>{"price"=>"790000.00", "images_attributes"=>{"1272227628590"=>{"data"=>#<File:/tmp/RackMultipart20100426-29038-1jfwwnu-0>, "_destroy"=>""}}, "title"=>"Apple In-Ear Headphones with Remote and Mic", "category_id"=>"1", "description"=>"<div class=\"prod-desc\">Hear every detail of your music every time you tune in with the  Apple In-Ear Headphones with Remote and Mic. They offer pro audio  performance and impressive sound isolation, and convenient buttons let  you adjust the volume and control music and video playback.Rediscover  your music.Put on the Apple In-Ear Headphones, select your favorite  track, and hear musical details you never knew existed. It's almost like  you're experiencing your music for the first time.Technical  SpecificationsFrequency response: 5Hz to 21kHzImpedance (at 100Hz): 23  ohmsSensitivity (at 100Hz): 109 dB SPL/mWDrivers: Custom two-way  balanced armature (woofer and tweeter in each earpiece)</div>"}, "controller"=>"products"}
    UserSession.create(users(:end_user))
    #pic1 = fixture_file_upload('../files/test_pic_1.jpg', 'image/jpg')
    #post :create, :product => { :title => "PG OO Raiser", :price => "3500000", :weight => "5", :images_attributes => { "1" => { :data => pic1}, "2" => { :data => pic1 } } }
    post :create, :product => { :title => "PG OO Raiser", :price => "3500000", :weight => "5" }
    assert_response :redirect
    assert_redirected_to products_path
  end

  test "should not create product without price for register user" do
    UserSession.create(users(:end_user))
    pic1 = fixture_file_upload('../files/test_pic_1.jpg', 'image/jpg')
    post :create, :product => { :title => "PG OO Raiser", :price => "", :images_attributes => { "1" => { :data => pic1}, "2" => { :data => pic1 } } }
    assert_response :success
    assert_template :new
  end

  test "should not create product when price is not numeric for register user" do
    UserSession.create(users(:end_user))
    pic1 = fixture_file_upload('../files/test_pic_1.jpg', 'image/jpg')
    post :create, :product => { :title => "PG OO Raiser", :price => "abc", :images_attributes => { "1" => { :data => pic1}, "2" => { :data => pic1 } } }
    assert_response :success
    assert_template :new
  end

  test "should not create product without title for register user" do
    UserSession.create(users(:end_user))
    pic1 = fixture_file_upload('../files/test_pic_1.jpg', 'image/jpg')
    post :create, :product => { :title => "", :price => "3500000", :images_attributes => { "1" => { :data => pic1}, "2" => { :data => pic1 } } }
    assert_response :success
    assert_template :new
  end

  test "should destroy product for register user" do
    UserSession.create(users(:end_user))
    delete :destroy, :id => products(:jazzy_big_hat_product).id
    assert_response :redirect
    assert_redirected_to products_path
  end

  private
  def initialize_register_user
    #erase all import products
    shop = shops(:fashion_shop)
    shop.products.where('feed_source <> 0').each do |p|
      p.destroy
    end
  end

end
