require 'test_helper'

class Manage::VenuesControllerTest < ActionController::TestCase
  setup do
    @manage_venue = manage_venues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_venues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_venue" do
    assert_difference('Manage::Venue.count') do
      post :create, manage_venue: @manage_venue.attributes
    end

    assert_redirected_to manage_venue_path(assigns(:manage_venue))
  end

  test "should show manage_venue" do
    get :show, id: @manage_venue.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_venue.to_param
    assert_response :success
  end

  test "should update manage_venue" do
    put :update, id: @manage_venue.to_param, manage_venue: @manage_venue.attributes
    assert_redirected_to manage_venue_path(assigns(:manage_venue))
  end

  test "should destroy manage_venue" do
    assert_difference('Manage::Venue.count', -1) do
      delete :destroy, id: @manage_venue.to_param
    end

    assert_redirected_to manage_venues_path
  end
end
