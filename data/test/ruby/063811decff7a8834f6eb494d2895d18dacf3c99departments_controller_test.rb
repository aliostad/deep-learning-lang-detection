require 'test_helper'

class Manage::DepartmentsControllerTest < ActionController::TestCase
  setup do
    @manage_department = manage_departments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_departments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_department" do
    assert_difference('Manage::Department.count') do
      post :create, manage_department: {  }
    end

    assert_redirected_to manage_department_path(assigns(:manage_department))
  end

  test "should show manage_department" do
    get :show, id: @manage_department
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_department
    assert_response :success
  end

  test "should update manage_department" do
    patch :update, id: @manage_department, manage_department: {  }
    assert_redirected_to manage_department_path(assigns(:manage_department))
  end

  test "should destroy manage_department" do
    assert_difference('Manage::Department.count', -1) do
      delete :destroy, id: @manage_department
    end

    assert_redirected_to manage_departments_path
  end
end
