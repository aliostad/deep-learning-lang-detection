require 'test_helper'

class Api::StatesControllerTest < ActionController::TestCase
  setup do
    @api_state = api_states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_state" do
    assert_difference('Api::State.count') do
      post :create, api_state: {  }
    end

    assert_redirected_to api_state_path(assigns(:api_state))
  end

  test "should show api_state" do
    get :show, id: @api_state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_state
    assert_response :success
  end

  test "should update api_state" do
    patch :update, id: @api_state, api_state: {  }
    assert_redirected_to api_state_path(assigns(:api_state))
  end

  test "should destroy api_state" do
    assert_difference('Api::State.count', -1) do
      delete :destroy, id: @api_state
    end

    assert_redirected_to api_states_path
  end
end
