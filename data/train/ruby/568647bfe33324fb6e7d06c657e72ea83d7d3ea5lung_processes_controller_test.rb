require 'test_helper'

class LungProcessesControllerTest < ActionController::TestCase
  setup do
    @lung_process = lung_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lung_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lung_process" do
    assert_difference('LungProcess.count') do
      post :create, lung_process: { amplified: @lung_process.amplified, barcode: @lung_process.barcode, ctc_id: @lung_process.ctc_id, ePCR: @lung_process.ePCR, library: @lung_process.library, picked: @lung_process.picked, run_complete: @lung_process.run_complete, run_name: @lung_process.run_name, running: @lung_process.running, xsq_filenames: @lung_process.xsq_filenames, xsq_stored: @lung_process.xsq_stored }
    end

    assert_redirected_to lung_process_path(assigns(:lung_process))
  end

  test "should show lung_process" do
    get :show, id: @lung_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lung_process
    assert_response :success
  end

  test "should update lung_process" do
    put :update, id: @lung_process, lung_process: { amplified: @lung_process.amplified, barcode: @lung_process.barcode, ctc_id: @lung_process.ctc_id, ePCR: @lung_process.ePCR, library: @lung_process.library, picked: @lung_process.picked, run_complete: @lung_process.run_complete, run_name: @lung_process.run_name, running: @lung_process.running, xsq_filenames: @lung_process.xsq_filenames, xsq_stored: @lung_process.xsq_stored }
    assert_redirected_to lung_process_path(assigns(:lung_process))
  end

  test "should destroy lung_process" do
    assert_difference('LungProcess.count', -1) do
      delete :destroy, id: @lung_process
    end

    assert_redirected_to lung_processes_path
  end
end
