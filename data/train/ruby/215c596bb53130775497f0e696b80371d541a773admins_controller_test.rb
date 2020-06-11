require 'test_helper'

class Manage::AdminsControllerTest < ActionController::TestCase
  setup do
    #登陆
    @manage_admin = manage_admins(:valid_admin)
    session[:admin_id] = @manage_admin.id
    session[:admin_realname] = @manage_admin.realname
    session[:admin_name] = @manage_admin.name
    #旧密码
    @op = 'password'
    @wrong_op = 'wrong _old_password'
    #验证码
    session[:manage_vcode] = 'ABCD'
  end

  test "进入修改页" do
    get :edit_self
    assert_response :success
  end

  test "成功修改个人信息" do
    post :update_self,
          id: @manage_admin,
          vcode: session[:manage_vcode],
          old_password: @op,
          manage_admin: {
              is_forbidden: @manage_admin.is_forbidden,
              password: "new_password",
              realname: @manage_admin.realname,
              name: @manage_admin.name
          }
    assert_redirected_to manage_admins_edit_self_path
    assert_equal "修改成功", flash[:notice]
    assert_equal session[:admin_realname],@manage_admin.realname
  end

  test "验证码错误,修改个人信息失败" do
    post :update_self,
          id: @manage_admin,
          vcode: 'asdf',
          old_password: @op,
          manage_admin: {
              is_forbidden: @manage_admin.is_forbidden,
              password: "new_password",
              realname: @manage_admin.realname,
              name: @manage_admin.name
          }
    assert_redirected_to manage_admins_edit_self_path
    assert_equal flash[:alert], '请输入正确的验证码'
  end

  test "原密码错误,修改个人信息失败" do
    post :update_self,
          id: @manage_admin,
          vcode: session[:manage_vcode],
          old_password: @wrong_op,
          manage_admin: {
              is_forbidden: @manage_admin.is_forbidden,
              password: "new_password",
              realname: @manage_admin.realname,
              name: @manage_admin.name
          }
    assert_redirected_to manage_admins_edit_self_path
    assert_equal flash[:alert], '原密码错误，修改个人信息失败'
  end
  # setup do
  #   @manage_admin = manage_admins(:one)
  # end
  #
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:manage_admins)
  # end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  #
  # test "should create manage_admin" do
  #   assert_difference('Manage::Admin.count') do
  #     post :create, manage_admin: { is_forbidden: @manage_admin.is_forbidden, password: @manage_admin.password, realname: @manage_admin.realname, uid: @manage_admin.uid }
  #   end
  #
  #   assert_redirected_to manage_admin_path(assigns(:manage_admin))
  # end
  #
  # test "should show manage_admin" do
  #   get :show, id: @manage_admin
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get :edit, id: @manage_admin
  #   assert_response :success
  # end
  #
  # test "should update manage_admin" do
  #   patch :update, id: @manage_admin, manage_admin: { is_forbidden: @manage_admin.is_forbidden, password: @manage_admin.password, realname: @manage_admin.realname, uid: @manage_admin.uid }
  #   assert_redirected_to manage_admin_path(assigns(:manage_admin))
  # end
  #
  # test "should destroy manage_admin" do
  #   assert_difference('Manage::Admin.count', -1) do
  #     delete :destroy, id: @manage_admin
  #   end
  #
  #   assert_redirected_to manage_admins_path
  # end
end
