require "test_helper"

class PatientsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get patients_dashboard_url
    assert_response :success
  end

  test "should get edit_password" do
    get patients_edit_password_url
    assert_response :success
  end

  test "should get update_password" do
    get patients_update_password_url
    assert_response :success
  end
end
