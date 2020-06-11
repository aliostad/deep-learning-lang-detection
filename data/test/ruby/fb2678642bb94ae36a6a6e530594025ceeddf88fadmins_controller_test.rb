require 'test_helper'

class Manage::AdminsControllerTest < ActionController::TestCase
  setup do
    @manage_admin = manage_admins(:admin_one)
    admin_login
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_admins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_admin" do
    assert_difference('Manage::Admin.count') do
      post :create, manage_admin: { desc: @manage_admin.desc, email: @manage_admin.email, is_enabled: @manage_admin.is_enabled, nickname: @manage_admin.nickname, password: @manage_admin.password, uid: @manage_admin.uid }
    end

    assert_redirected_to manage_admin_path(assigns(:manage_admin))
  end

  test "should show manage_admin" do
    get :show, id: @manage_admin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_admin
    assert_response :success
  end

  test "should update manage_admin" do
    patch :update, id: @manage_admin, manage_admin: { desc: @manage_admin.desc, email: @manage_admin.email, is_enabled: @manage_admin.is_enabled, nickname: @manage_admin.nickname, password: @manage_admin.password, uid: @manage_admin.uid }
    assert_redirected_to manage_admin_path(assigns(:manage_admin))
  end

  test "should destroy manage_admin" do
    assert_difference('Manage::Admin.count', -1) do
      delete :destroy, id: @manage_admin
    end

    assert_redirected_to manage_admins_path
  end
end
