require 'test_helper'

class BulkImportControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "should show bulk import page" do
    UserSession.create(users(:end_user))
    get :index
    assert_response :success
    assert_template :index
  end

end
