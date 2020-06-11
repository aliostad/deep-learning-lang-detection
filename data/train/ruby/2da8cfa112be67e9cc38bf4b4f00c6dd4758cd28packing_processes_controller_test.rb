require 'test_helper'

class PackingProcessesControllerTest < ActionController::TestCase
  setup do
    @packing_process = packing_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:packing_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create packing_process" do
    assert_difference('PackingProcess.count') do
      post :create, packing_process: { name: @packing_process.name }
    end

    assert_redirected_to packing_process_path(assigns(:packing_process))
  end

  test "should show packing_process" do
    get :show, id: @packing_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @packing_process
    assert_response :success
  end

  test "should update packing_process" do
    put :update, id: @packing_process, packing_process: { name: @packing_process.name }
    assert_redirected_to packing_process_path(assigns(:packing_process))
  end

  test "should destroy packing_process" do
    assert_difference('PackingProcess.count', -1) do
      delete :destroy, id: @packing_process
    end

    assert_redirected_to packing_processes_path
  end
end
