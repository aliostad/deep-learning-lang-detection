require 'test_helper'

class ProcessMastersControllerTest < ActionController::TestCase
  setup do
    @process_master = process_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_master" do
    assert_difference('ProcessMaster.count') do
      post :create, process_master: {  }
    end

    assert_redirected_to process_master_path(assigns(:process_master))
  end

  test "should show process_master" do
    get :show, id: @process_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_master
    assert_response :success
  end

  test "should update process_master" do
    patch :update, id: @process_master, process_master: {  }
    assert_redirected_to process_master_path(assigns(:process_master))
  end

  test "should destroy process_master" do
    assert_difference('ProcessMaster.count', -1) do
      delete :destroy, id: @process_master
    end

    assert_redirected_to process_masters_path
  end
end
