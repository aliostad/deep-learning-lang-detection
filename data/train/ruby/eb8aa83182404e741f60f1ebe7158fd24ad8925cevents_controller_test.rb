require 'test_helper'

class Manage::EventsControllerTest < ActionController::TestCase
  setup do
    @manage_event = manage_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_event" do
    assert_difference('Manage::Event.count') do
      post :create, manage_event: @manage_event.attributes
    end

    assert_redirected_to manage_event_path(assigns(:manage_event))
  end

  test "should show manage_event" do
    get :show, id: @manage_event.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_event.to_param
    assert_response :success
  end

  test "should update manage_event" do
    put :update, id: @manage_event.to_param, manage_event: @manage_event.attributes
    assert_redirected_to manage_event_path(assigns(:manage_event))
  end

  test "should destroy manage_event" do
    assert_difference('Manage::Event.count', -1) do
      delete :destroy, id: @manage_event.to_param
    end

    assert_redirected_to manage_events_path
  end
end
