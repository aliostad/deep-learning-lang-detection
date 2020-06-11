require 'test_helper'

class Manage::CompetesControllerTest < ActionController::TestCase
  setup do
    @manage_compete = manage_competes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_competes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_compete" do
    assert_difference('Manage::Compete.count') do
      post :create, manage_compete: { admin_id: @manage_compete.admin_id, contest_id: @manage_compete.contest_id, end_time: @manage_compete.end_time, start_time: @manage_compete.start_time }
    end

    assert_redirected_to manage_compete_path(assigns(:manage_compete))
  end

  test "should show manage_compete" do
    get :show, id: @manage_compete
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_compete
    assert_response :success
  end

  test "should update manage_compete" do
    patch :update, id: @manage_compete, manage_compete: { admin_id: @manage_compete.admin_id, contest_id: @manage_compete.contest_id, end_time: @manage_compete.end_time, start_time: @manage_compete.start_time }
    assert_redirected_to manage_compete_path(assigns(:manage_compete))
  end

  test "should destroy manage_compete" do
    assert_difference('Manage::Compete.count', -1) do
      delete :destroy, id: @manage_compete
    end

    assert_redirected_to manage_competes_path
  end
end
