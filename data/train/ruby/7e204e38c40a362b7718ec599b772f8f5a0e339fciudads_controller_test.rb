require 'test_helper'

class Api::CiudadsControllerTest < ActionController::TestCase
  setup do
    @api_ciudad = api_ciudads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_ciudads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_ciudad" do
    assert_difference('Api::Ciudad.count') do
      post :create, api_ciudad: {  }
    end

    assert_redirected_to api_ciudad_path(assigns(:api_ciudad))
  end

  test "should show api_ciudad" do
    get :show, id: @api_ciudad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_ciudad
    assert_response :success
  end

  test "should update api_ciudad" do
    patch :update, id: @api_ciudad, api_ciudad: {  }
    assert_redirected_to api_ciudad_path(assigns(:api_ciudad))
  end

  test "should destroy api_ciudad" do
    assert_difference('Api::Ciudad.count', -1) do
      delete :destroy, id: @api_ciudad
    end

    assert_redirected_to api_ciudads_path
  end
end
