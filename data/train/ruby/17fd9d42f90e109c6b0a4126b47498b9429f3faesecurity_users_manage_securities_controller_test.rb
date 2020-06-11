require 'test_helper'

class SecurityUsersManageSecuritiesControllerTest < ActionController::TestCase
  setup do
    @security_users_manage_security = security_users_manage_securities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:security_users_manage_securities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create security_users_manage_security" do
    assert_difference('SecurityUsersManageSecurity.count') do
      post :create, security_users_manage_security: {  }
    end

    assert_redirected_to security_users_manage_security_path(assigns(:security_users_manage_security))
  end

  test "should show security_users_manage_security" do
    get :show, id: @security_users_manage_security
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @security_users_manage_security
    assert_response :success
  end

  test "should update security_users_manage_security" do
    put :update, id: @security_users_manage_security, security_users_manage_security: {  }
    assert_redirected_to security_users_manage_security_path(assigns(:security_users_manage_security))
  end

  test "should destroy security_users_manage_security" do
    assert_difference('SecurityUsersManageSecurity.count', -1) do
      delete :destroy, id: @security_users_manage_security
    end

    assert_redirected_to security_users_manage_securities_path
  end
end
