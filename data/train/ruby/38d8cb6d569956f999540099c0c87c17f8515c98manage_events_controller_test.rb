require 'test_helper'

class ManageEventsControllerTest < ActionController::TestCase
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
    assert_difference('ManageEvent.count') do
      post :create, manage_event: { author: @manage_event.author, category: @manage_event.category, desc: @manage_event.desc, event_date: @manage_event.event_date, event_image: @manage_event.event_image, title: @manage_event.title }
    end

    assert_redirected_to manage_event_path(assigns(:manage_event))
  end

  test "should show manage_event" do
    get :show, id: @manage_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_event
    assert_response :success
  end

  test "should update manage_event" do
    patch :update, id: @manage_event, manage_event: { author: @manage_event.author, category: @manage_event.category, desc: @manage_event.desc, event_date: @manage_event.event_date, event_image: @manage_event.event_image, title: @manage_event.title }
    assert_redirected_to manage_event_path(assigns(:manage_event))
  end

  test "should destroy manage_event" do
    assert_difference('ManageEvent.count', -1) do
      delete :destroy, id: @manage_event
    end

    assert_redirected_to manage_events_path
  end
end
