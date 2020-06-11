require 'test_helper'

class Manage::SchedulesControllerTest < ActionController::TestCase
  setup do
    @manage_schedule = manage_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_schedule" do
    assert_difference('Manage::Schedule.count') do
      post :create, manage_schedule: @manage_schedule.attributes
    end

    assert_redirected_to manage_schedule_path(assigns(:manage_schedule))
  end

  test "should show manage_schedule" do
    get :show, id: @manage_schedule.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_schedule.to_param
    assert_response :success
  end

  test "should update manage_schedule" do
    put :update, id: @manage_schedule.to_param, manage_schedule: @manage_schedule.attributes
    assert_redirected_to manage_schedule_path(assigns(:manage_schedule))
  end

  test "should destroy manage_schedule" do
    assert_difference('Manage::Schedule.count', -1) do
      delete :destroy, id: @manage_schedule.to_param
    end

    assert_redirected_to manage_schedules_path
  end
end
