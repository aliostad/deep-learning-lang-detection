require 'test_helper'

class Manage::OfficeLocationsControllerTest < ActionController::TestCase
  setup do
    @manage_office_location = manage_office_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_office_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_office_location" do
    assert_difference('Manage::OfficeLocation.count') do
      post :create, manage_office_location: {  }
    end

    assert_redirected_to manage_office_location_path(assigns(:manage_office_location))
  end

  test "should show manage_office_location" do
    get :show, id: @manage_office_location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_office_location
    assert_response :success
  end

  test "should update manage_office_location" do
    patch :update, id: @manage_office_location, manage_office_location: {  }
    assert_redirected_to manage_office_location_path(assigns(:manage_office_location))
  end

  test "should destroy manage_office_location" do
    assert_difference('Manage::OfficeLocation.count', -1) do
      delete :destroy, id: @manage_office_location
    end

    assert_redirected_to manage_office_locations_path
  end
end
