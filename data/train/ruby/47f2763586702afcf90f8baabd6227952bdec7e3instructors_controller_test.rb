require 'test_helper'

class Manage::InstructorsControllerTest < ActionController::TestCase
  setup do
    @manage_instructor = manage_instructors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_instructors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_instructor" do
    assert_difference('Manage::Instructor.count') do
      post :create, manage_instructor: @manage_instructor.attributes
    end

    assert_redirected_to manage_instructor_path(assigns(:manage_instructor))
  end

  test "should show manage_instructor" do
    get :show, id: @manage_instructor.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_instructor.to_param
    assert_response :success
  end

  test "should update manage_instructor" do
    put :update, id: @manage_instructor.to_param, manage_instructor: @manage_instructor.attributes
    assert_redirected_to manage_instructor_path(assigns(:manage_instructor))
  end

  test "should destroy manage_instructor" do
    assert_difference('Manage::Instructor.count', -1) do
      delete :destroy, id: @manage_instructor.to_param
    end

    assert_redirected_to manage_instructors_path
  end
end
