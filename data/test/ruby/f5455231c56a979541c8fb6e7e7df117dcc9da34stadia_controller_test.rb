require 'test_helper'

class Api::StadiaControllerTest < ActionController::TestCase
  setup do
    @api_stadium = api_stadia(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_stadia)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_stadium" do
    assert_difference('Api::Stadium.count') do
      post :create, api_stadium: {  }
    end

    assert_redirected_to api_stadium_path(assigns(:api_stadium))
  end

  test "should show api_stadium" do
    get :show, id: @api_stadium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_stadium
    assert_response :success
  end

  test "should update api_stadium" do
    patch :update, id: @api_stadium, api_stadium: {  }
    assert_redirected_to api_stadium_path(assigns(:api_stadium))
  end

  test "should destroy api_stadium" do
    assert_difference('Api::Stadium.count', -1) do
      delete :destroy, id: @api_stadium
    end

    assert_redirected_to api_stadia_path
  end
end
