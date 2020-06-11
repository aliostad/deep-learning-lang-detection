require 'test_helper'

class PancreasProcessesControllerTest < ActionController::TestCase
  setup do
    @pancreas_process = pancreas_processes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pancreas_processes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pancreas_process" do
    assert_difference('PancreasProcess.count') do
      post :create, pancreas_process: { amplified: @pancreas_process.amplified, barcode: @pancreas_process.barcode, ctc_id: @pancreas_process.ctc_id, data_analyzed: @pancreas_process.data_analyzed, ePCR: @pancreas_process.ePCR, library: @pancreas_process.library, output_files: @pancreas_process.output_files, output_stored: @pancreas_process.output_stored, picked: @pancreas_process.picked, run_complete: @pancreas_process.run_complete, run_name: @pancreas_process.run_name, running: @pancreas_process.running, xsq_filenames: @pancreas_process.xsq_filenames, xsq_stored: @pancreas_process.xsq_stored }
    end

    assert_redirected_to pancreas_process_path(assigns(:pancreas_process))
  end

  test "should show pancreas_process" do
    get :show, id: @pancreas_process
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pancreas_process
    assert_response :success
  end

  test "should update pancreas_process" do
    put :update, id: @pancreas_process, pancreas_process: { amplified: @pancreas_process.amplified, barcode: @pancreas_process.barcode, ctc_id: @pancreas_process.ctc_id, data_analyzed: @pancreas_process.data_analyzed, ePCR: @pancreas_process.ePCR, library: @pancreas_process.library, output_files: @pancreas_process.output_files, output_stored: @pancreas_process.output_stored, picked: @pancreas_process.picked, run_complete: @pancreas_process.run_complete, run_name: @pancreas_process.run_name, running: @pancreas_process.running, xsq_filenames: @pancreas_process.xsq_filenames, xsq_stored: @pancreas_process.xsq_stored }
    assert_redirected_to pancreas_process_path(assigns(:pancreas_process))
  end

  test "should destroy pancreas_process" do
    assert_difference('PancreasProcess.count', -1) do
      delete :destroy, id: @pancreas_process
    end

    assert_redirected_to pancreas_processes_path
  end
end
