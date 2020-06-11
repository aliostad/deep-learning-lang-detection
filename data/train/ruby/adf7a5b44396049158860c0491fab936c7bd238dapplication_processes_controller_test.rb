require 'test_helper'

class ApplicationProcessesControllerTest < ActionController::TestCase
  setup do
    @application_process = application_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:application_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create application_process" do
    assert_difference('ApplicationProcess.count') do
      post :create, application_process: { application_form: @application_process.application_form, message: @application_process.message, purpose: @application_process.purpose, reffer_to_id: @application_process.reffer_to_id, refferer_id: @application_process.refferer_id, status: @application_process.status }
    end

    assert_redirected_to application_process_path(assigns(:application_process))
  end

  test "should show application_process" do
    get :show, id: @application_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @application_process
    assert_response :success
  end

  test "should update application_process" do
    put :update, id: @application_process, application_process: { application_form: @application_process.application_form, message: @application_process.message, purpose: @application_process.purpose, reffer_to_id: @application_process.reffer_to_id, refferer_id: @application_process.refferer_id, status: @application_process.status }
    assert_redirected_to application_process_path(assigns(:application_process))
  end

  test "should destroy application_process" do
    assert_difference('ApplicationProcess.count', -1) do
      delete :destroy, id: @application_process
    end

    assert_redirected_to application_processes_path
  end
end
