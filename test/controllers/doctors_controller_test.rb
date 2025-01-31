require "test_helper"

class DoctorsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get doctors_dashboard_url
    assert_response :success
  end
end
