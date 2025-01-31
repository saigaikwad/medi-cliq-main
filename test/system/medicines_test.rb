require "application_system_test_case"

class MedicinesTest < ApplicationSystemTestCase
  setup do
    @medicine = medicines(:one)
  end

  test "visiting the index" do
    visit medicines_url
    assert_selector "h1", text: "Medicines"
  end

  test "should create medicine" do
    visit medicines_url
    click_on "New medicine"

    fill_in "Batch no", with: @medicine.batch_no
    fill_in "Category", with: @medicine.category_id
    fill_in "Exp date", with: @medicine.exp_date
    fill_in "Form", with: @medicine.form
    fill_in "Manufacturer", with: @medicine.manufacturer
    fill_in "Name", with: @medicine.name
    check "Prescribed" if @medicine.prescribed
    click_on "Create Medicine"

    assert_text "Medicine was successfully created"
    click_on "Back"
  end

  test "should update Medicine" do
    visit medicine_url(@medicine)
    click_on "Edit this medicine", match: :first

    fill_in "Batch no", with: @medicine.batch_no
    fill_in "Category", with: @medicine.category_id
    fill_in "Exp date", with: @medicine.exp_date
    fill_in "Form", with: @medicine.form
    fill_in "Manufacturer", with: @medicine.manufacturer
    fill_in "Name", with: @medicine.name
    check "Prescribed" if @medicine.prescribed
    click_on "Update Medicine"

    assert_text "Medicine was successfully updated"
    click_on "Back"
  end

  test "should destroy Medicine" do
    visit medicine_url(@medicine)
    click_on "Destroy this medicine", match: :first

    assert_text "Medicine was successfully destroyed"
  end
end
