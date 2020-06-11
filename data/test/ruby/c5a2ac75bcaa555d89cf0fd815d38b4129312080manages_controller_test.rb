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
      post :create, manage: {  }
    end

    assert_redirected_to manage_path(assigns(:manage))
  end

  test "should show manage" do
    get :show, id: @manage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage
    assert_response :success
  end

  test "should update manage" do
    patch :update, id: @manage, manage: {  }
    assert_redirected_to manage_path(assigns(:manage))
  end

  test "should destroy manage" do
    assert_difference('Manage.count', -1) do
      delete :destroy, id: @manage
    end

    assert_redirected_to manages_path
  end
end
