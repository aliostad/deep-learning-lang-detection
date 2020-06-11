require 'test_helper'

class Api::VuelosControllerTest < ActionController::TestCase
  setup do
    @api_vuelo = api_vuelos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_vuelos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_vuelo" do
    assert_difference('Api::Vuelo.count') do
      post :create, api_vuelo: {  }
    end

    assert_redirected_to api_vuelo_path(assigns(:api_vuelo))
  end

  test "should show api_vuelo" do
    get :show, id: @api_vuelo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_vuelo
    assert_response :success
  end

  test "should update api_vuelo" do
    patch :update, id: @api_vuelo, api_vuelo: {  }
    assert_redirected_to api_vuelo_path(assigns(:api_vuelo))
  end

  test "should destroy api_vuelo" do
    assert_difference('Api::Vuelo.count', -1) do
      delete :destroy, id: @api_vuelo
    end

    assert_redirected_to api_vuelos_path
  end
end
