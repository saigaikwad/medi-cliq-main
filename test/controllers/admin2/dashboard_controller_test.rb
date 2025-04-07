require "test_helper"

class Admin2::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin2_dashboard_index_url
    assert_response :success
  end
end
