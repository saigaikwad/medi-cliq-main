require "test_helper"

class MedicinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @medicine = medicines(:one)
  end

  test "should get index" do
    get medicines_url
    assert_response :success
  end

  test "should get new" do
    get new_medicine_url
    assert_response :success
  end

  test "should create medicine" do
    assert_difference("Medicine.count") do
      post medicines_url, params: { medicine: { batch_no: @medicine.batch_no, category_id: @medicine.category_id, exp_date: @medicine.exp_date, form: @medicine.form, manufacturer: @medicine.manufacturer, name: @medicine.name, prescribed: @medicine.prescribed } }
    end

    assert_redirected_to medicine_url(Medicine.last)
  end

  test "should show medicine" do
    get medicine_url(@medicine)
    assert_response :success
  end

  test "should get edit" do
    get edit_medicine_url(@medicine)
    assert_response :success
  end

  test "should update medicine" do
    patch medicine_url(@medicine), params: { medicine: { batch_no: @medicine.batch_no, category_id: @medicine.category_id, exp_date: @medicine.exp_date, form: @medicine.form, manufacturer: @medicine.manufacturer, name: @medicine.name, prescribed: @medicine.prescribed } }
    assert_redirected_to medicine_url(@medicine)
  end

  test "should destroy medicine" do
    assert_difference("Medicine.count", -1) do
      delete medicine_url(@medicine)
    end

    assert_redirected_to medicines_url
  end
end
