require 'test_helper'

class OutsroucedProcessesControllerTest < ActionController::TestCase
  setup do
    @outsrouced_process = outsrouced_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:outsrouced_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create outsrouced_process" do
    assert_difference('OutsroucedProcess.count') do
      post :create, outsrouced_process: @outsrouced_process.attributes
    end

    assert_redirected_to outsrouced_process_path(assigns(:outsrouced_process))
  end

  test "should show outsrouced_process" do
    get :show, id: @outsrouced_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @outsrouced_process
    assert_response :success
  end

  test "should update outsrouced_process" do
    put :update, id: @outsrouced_process, outsrouced_process: @outsrouced_process.attributes
    assert_redirected_to outsrouced_process_path(assigns(:outsrouced_process))
  end

  test "should destroy outsrouced_process" do
    assert_difference('OutsroucedProcess.count', -1) do
      delete :destroy, id: @outsrouced_process
    end

    assert_redirected_to outsrouced_processes_path
  end
end
