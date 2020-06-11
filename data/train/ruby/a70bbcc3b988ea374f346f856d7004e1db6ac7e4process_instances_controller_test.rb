require 'test_helper'

class ProcessInstancesControllerTest < ActionController::TestCase
  setup do
    @process_instance = process_instances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_instances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_instance" do
    assert_difference('ProcessInstance.count') do
      post :create, process_instance: { company_id: @process_instance.company_id, created_by: @process_instance.created_by, process_id: @process_instance.process_id }
    end

    assert_redirected_to process_instance_path(assigns(:process_instance))
  end

  test "should show process_instance" do
    get :show, id: @process_instance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_instance
    assert_response :success
  end

  test "should update process_instance" do
    put :update, id: @process_instance, process_instance: { company_id: @process_instance.company_id, created_by: @process_instance.created_by, process_id: @process_instance.process_id }
    assert_redirected_to process_instance_path(assigns(:process_instance))
  end

  test "should destroy process_instance" do
    assert_difference('ProcessInstance.count', -1) do
      delete :destroy, id: @process_instance
    end

    assert_redirected_to process_instances_path
  end
end
