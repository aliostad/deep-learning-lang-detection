require 'test_helper'

class ProcessSpacesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_spaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_space" do
    assert_difference('ProcessSpace.count') do
      post :create, :process_space => { }
    end

    assert_redirected_to process_space_path(assigns(:process_space))
  end

  test "should show process_space" do
    get :show, :id => process_spaces(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => process_spaces(:one).to_param
    assert_response :success
  end

  test "should update process_space" do
    put :update, :id => process_spaces(:one).to_param, :process_space => { }
    assert_redirected_to process_space_path(assigns(:process_space))
  end

  test "should destroy process_space" do
    assert_difference('ProcessSpace.count', -1) do
      delete :destroy, :id => process_spaces(:one).to_param
    end

    assert_redirected_to process_spaces_path
  end
end
