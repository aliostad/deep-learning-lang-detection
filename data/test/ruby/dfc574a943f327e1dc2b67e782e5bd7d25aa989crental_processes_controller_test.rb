require 'test_helper'

module VPlanerRental
  class RentalProcessesControllerTest < ActionController::TestCase
    setup do
      @rental_process = rental_processes(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:rental_processes)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create rental_process" do
      assert_difference('RentalProcess.count') do
        post :create, :rental_process => { :billed_duration => @rental_process.billed_duration, :delivery_date => @rental_process.delivery_date, :end_date => @rental_process.end_date, :process_id => @rental_process.process_id, :return_date => @rental_process.return_date, :start_date => @rental_process.start_date }
      end
  
      assert_redirected_to rental_process_path(assigns(:rental_process))
    end
  
    test "should show rental_process" do
      get :show, :id => @rental_process
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, :id => @rental_process
      assert_response :success
    end
  
    test "should update rental_process" do
      put :update, :id => @rental_process, :rental_process => { :billed_duration => @rental_process.billed_duration, :delivery_date => @rental_process.delivery_date, :end_date => @rental_process.end_date, :process_id => @rental_process.process_id, :return_date => @rental_process.return_date, :start_date => @rental_process.start_date }
      assert_redirected_to rental_process_path(assigns(:rental_process))
    end
  
    test "should destroy rental_process" do
      assert_difference('RentalProcess.count', -1) do
        delete :destroy, :id => @rental_process
      end
  
      assert_redirected_to rental_processes_path
    end
  end
end
