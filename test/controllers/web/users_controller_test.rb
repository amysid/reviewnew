require 'test_helper'

class Web::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get web_users_index_url
    assert_response :success
  end

  test "should get show" do
    get web_users_show_url
    assert_response :success
  end

end
