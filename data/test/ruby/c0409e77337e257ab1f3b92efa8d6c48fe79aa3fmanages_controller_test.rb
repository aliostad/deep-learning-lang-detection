require 'test_helper'

class ManagesControllerTest < ActionController::TestCase
  setup do
    @manage = manages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage" do
    assert_difference('Manage.count') do
      post :create, :manage => @manage.attributes
    end

    assert_redirected_to manage_path(assigns(:manage))
  end

  test "should show manage" do
    get :show, :id => @manage.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @manage.to_param
    assert_response :success
  end

  test "should update manage" do
    put :update, :id => @manage.to_param, :manage => @manage.attributes
    assert_redirected_to manage_path(assigns(:manage))
  end

  test "should destroy manage" do
    assert_difference('Manage.count', -1) do
      delete :destroy, :id => @manage.to_param
    end

    assert_redirected_to manages_path
  end
end
