require 'test_helper'

class BreastProcessesControllerTest < ActionController::TestCase
  setup do
    @breast_process = breast_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:breast_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create breast_process" do
    assert_difference('BreastProcess.count') do
      post :create, breast_process: { amplified: @breast_process.amplified, barcode: @breast_process.barcode, ctc_id: @breast_process.ctc_id, ePCR: @breast_process.ePCR, library: @breast_process.library, picked: @breast_process.picked, run_complete: @breast_process.run_complete, run_name: @breast_process.run_name, running: @breast_process.running, xsq_filenames: @breast_process.xsq_filenames, xsq_stored: @breast_process.xsq_stored }
    end

    assert_redirected_to breast_process_path(assigns(:breast_process))
  end

  test "should show breast_process" do
    get :show, id: @breast_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @breast_process
    assert_response :success
  end

  test "should update breast_process" do
    put :update, id: @breast_process, breast_process: { amplified: @breast_process.amplified, barcode: @breast_process.barcode, ctc_id: @breast_process.ctc_id, ePCR: @breast_process.ePCR, library: @breast_process.library, picked: @breast_process.picked, run_complete: @breast_process.run_complete, run_name: @breast_process.run_name, running: @breast_process.running, xsq_filenames: @breast_process.xsq_filenames, xsq_stored: @breast_process.xsq_stored }
    assert_redirected_to breast_process_path(assigns(:breast_process))
  end

  test "should destroy breast_process" do
    assert_difference('BreastProcess.count', -1) do
      delete :destroy, id: @breast_process
    end

    assert_redirected_to breast_processes_path
  end
end
