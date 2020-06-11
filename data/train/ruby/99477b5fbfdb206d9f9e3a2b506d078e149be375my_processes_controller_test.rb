require 'test_helper'

class MyProcessesControllerTest < ActionController::TestCase
  setup do
    @my_process = my_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_process" do
    assert_difference('MyProcess.count') do
      post :create, my_process: { pid: @my_process.pid }
    end

    assert_redirected_to my_process_path(assigns(:my_process))
  end

  test "should show my_process" do
    get :show, id: @my_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_process
    assert_response :success
  end

  test "should update my_process" do
    patch :update, id: @my_process, my_process: { pid: @my_process.pid }
    assert_redirected_to my_process_path(assigns(:my_process))
  end

  test "should destroy my_process" do
    assert_difference('MyProcess.count', -1) do
      delete :destroy, id: @my_process
    end

    assert_redirected_to my_processes_path
  end
end
