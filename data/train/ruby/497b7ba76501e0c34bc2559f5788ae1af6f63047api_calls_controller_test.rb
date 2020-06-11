require 'test_helper'

class ApiCallsControllerTest < ActionController::TestCase
  setup do
    @api_call = api_calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_call" do
    assert_difference('ApiCall.count') do
      post :create, api_call: { doctor_id: @api_call.doctor_id, payer_id: @api_call.payer_id, payer_name: @api_call.payer_name, subscriber_dob: @api_call.subscriber_dob, subscriber_first_name: @api_call.subscriber_first_name, subscriber_id: @api_call.subscriber_id, subscriber_last_name: @api_call.subscriber_last_name }
    end

    assert_redirected_to api_call_path(assigns(:api_call))
  end

  test "should show api_call" do
    get :show, id: @api_call
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_call
    assert_response :success
  end

  test "should update api_call" do
    put :update, id: @api_call, api_call: { doctor_id: @api_call.doctor_id, payer_id: @api_call.payer_id, payer_name: @api_call.payer_name, subscriber_dob: @api_call.subscriber_dob, subscriber_first_name: @api_call.subscriber_first_name, subscriber_id: @api_call.subscriber_id, subscriber_last_name: @api_call.subscriber_last_name }
    assert_redirected_to api_call_path(assigns(:api_call))
  end

  test "should destroy api_call" do
    assert_difference('ApiCall.count', -1) do
      delete :destroy, id: @api_call
    end

    assert_redirected_to api_calls_path
  end
end
