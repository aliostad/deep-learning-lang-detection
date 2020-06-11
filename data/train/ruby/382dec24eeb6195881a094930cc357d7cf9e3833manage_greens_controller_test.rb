require 'test_helper'

class ManageGreensControllerTest < ActionController::TestCase
  setup do
    @manage_green = manage_greens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_greens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_green" do
    assert_difference('ManageGreen.count') do
      post :create, manage_green: { created_by: @manage_green.created_by, desc: @manage_green.desc, image: @manage_green.image, sub_category: @manage_green.sub_category, title: @manage_green.title }
    end

    assert_redirected_to manage_green_path(assigns(:manage_green))
  end

  test "should show manage_green" do
    get :show, id: @manage_green
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_green
    assert_response :success
  end

  test "should update manage_green" do
    patch :update, id: @manage_green, manage_green: { created_by: @manage_green.created_by, desc: @manage_green.desc, image: @manage_green.image, sub_category: @manage_green.sub_category, title: @manage_green.title }
    assert_redirected_to manage_green_path(assigns(:manage_green))
  end

  test "should destroy manage_green" do
    assert_difference('ManageGreen.count', -1) do
      delete :destroy, id: @manage_green
    end

    assert_redirected_to manage_greens_path
  end
end
