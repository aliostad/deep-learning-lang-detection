require 'test_helper'

class ProstateProcessesControllerTest < ActionController::TestCase
  setup do
    @prostate_process = prostate_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prostate_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prostate_process" do
    assert_difference('ProstateProcess.count') do
      post :create, prostate_process: { amplified: @prostate_process.amplified, barcode: @prostate_process.barcode, ctc_id: @prostate_process.ctc_id, data_analyzed: @prostate_process.data_analyzed, ePCR: @prostate_process.ePCR, library: @prostate_process.library, output_files: @prostate_process.output_files, output_stored: @prostate_process.output_stored, picked: @prostate_process.picked, run_complete: @prostate_process.run_complete, run_name: @prostate_process.run_name, running: @prostate_process.running, xsq_filenames: @prostate_process.xsq_filenames, xsq_stored: @prostate_process.xsq_stored }
    end

    assert_redirected_to prostate_process_path(assigns(:prostate_process))
  end

  test "should show prostate_process" do
    get :show, id: @prostate_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prostate_process
    assert_response :success
  end

  test "should update prostate_process" do
    put :update, id: @prostate_process, prostate_process: { amplified: @prostate_process.amplified, barcode: @prostate_process.barcode, ctc_id: @prostate_process.ctc_id, data_analyzed: @prostate_process.data_analyzed, ePCR: @prostate_process.ePCR, library: @prostate_process.library, output_files: @prostate_process.output_files, output_stored: @prostate_process.output_stored, picked: @prostate_process.picked, run_complete: @prostate_process.run_complete, run_name: @prostate_process.run_name, running: @prostate_process.running, xsq_filenames: @prostate_process.xsq_filenames, xsq_stored: @prostate_process.xsq_stored }
    assert_redirected_to prostate_process_path(assigns(:prostate_process))
  end

  test "should destroy prostate_process" do
    assert_difference('ProstateProcess.count', -1) do
      delete :destroy, id: @prostate_process
    end

    assert_redirected_to prostate_processes_path
  end
end
