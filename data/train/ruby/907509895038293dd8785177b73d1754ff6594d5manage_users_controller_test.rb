require 'test_helper'

class Admin::ManageUsersControllerTest < ActionController::TestCase
  setup do
    @admin_manage_user = admin_manage_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_manage_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_manage_user" do
    assert_difference('Admin::ManageUser.count') do
      post :create, admin_manage_user: { password: @admin_manage_user.password, user_name: @admin_manage_user.user_name }
    end

    assert_redirected_to admin_manage_user_path(assigns(:admin_manage_user))
  end

  test "should show admin_manage_user" do
    get :show, id: @admin_manage_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_manage_user
    assert_response :success
  end

  test "should update admin_manage_user" do
    patch :update, id: @admin_manage_user, admin_manage_user: { password: @admin_manage_user.password, user_name: @admin_manage_user.user_name }
    assert_redirected_to admin_manage_user_path(assigns(:admin_manage_user))
  end

  test "should destroy admin_manage_user" do
    assert_difference('Admin::ManageUser.count', -1) do
      delete :destroy, id: @admin_manage_user
    end

    assert_redirected_to admin_manage_users_path
  end
end
