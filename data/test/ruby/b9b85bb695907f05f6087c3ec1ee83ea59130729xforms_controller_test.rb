require 'test_helper'

class Manage::XformsControllerTest < ActionController::TestCase
  setup do
    @manage_xform = manage_xforms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_xforms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_xform" do
    assert_difference('Manage::Xform.count') do
      post :create, manage_xform: {  }
    end

    assert_redirected_to manage_xform_path(assigns(:manage_xform))
  end

  test "should show manage_xform" do
    get :show, id: @manage_xform
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_xform
    assert_response :success
  end

  test "should update manage_xform" do
    patch :update, id: @manage_xform, manage_xform: {  }
    assert_redirected_to manage_xform_path(assigns(:manage_xform))
  end

  test "should destroy manage_xform" do
    assert_difference('Manage::Xform.count', -1) do
      delete :destroy, id: @manage_xform
    end

    assert_redirected_to manage_xforms_path
  end
end
