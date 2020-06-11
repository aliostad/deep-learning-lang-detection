require 'test_helper'

class Api::MessagesControllerTest < ActionController::TestCase
  setup do
    @api_message = api_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_message" do
    assert_difference('Api::Message.count') do
      post :create, api_message: {  }
    end

    assert_redirected_to api_message_path(assigns(:api_message))
  end

  test "should show api_message" do
    get :show, id: @api_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_message
    assert_response :success
  end

  test "should update api_message" do
    put :update, id: @api_message, api_message: {  }
    assert_redirected_to api_message_path(assigns(:api_message))
  end

  test "should destroy api_message" do
    assert_difference('Api::Message.count', -1) do
      delete :destroy, id: @api_message
    end

    assert_redirected_to api_messages_path
  end
end
