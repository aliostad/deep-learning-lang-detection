require 'test_helper'

class NumberManagesControllerTest < ActionController::TestCase
  setup do
    @number_manage = number_manages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:number_manages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create number_manage" do
    assert_difference('NumberManage.count') do
      post :create, number_manage: { order_type: @number_manage.order_type }
    end

    assert_redirected_to number_manage_path(assigns(:number_manage))
  end

  test "should show number_manage" do
    get :show, id: @number_manage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @number_manage
    assert_response :success
  end

  test "should update number_manage" do
    put :update, id: @number_manage, number_manage: { order_type: @number_manage.order_type }
    assert_redirected_to number_manage_path(assigns(:number_manage))
  end

  test "should destroy number_manage" do
    assert_difference('NumberManage.count', -1) do
      delete :destroy, id: @number_manage
    end

    assert_redirected_to number_manages_path
  end
end
