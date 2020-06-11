require 'test_helper'

class Api::AvionesControllerTest < ActionController::TestCase
  setup do
    @api_avione = api_aviones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_aviones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_avione" do
    assert_difference('Api::Avione.count') do
      post :create, api_avione: {  }
    end

    assert_redirected_to api_avione_path(assigns(:api_avione))
  end

  test "should show api_avione" do
    get :show, id: @api_avione
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_avione
    assert_response :success
  end

  test "should update api_avione" do
    patch :update, id: @api_avione, api_avione: {  }
    assert_redirected_to api_avione_path(assigns(:api_avione))
  end

  test "should destroy api_avione" do
    assert_difference('Api::Avione.count', -1) do
      delete :destroy, id: @api_avione
    end

    assert_redirected_to api_aviones_path
  end
end
