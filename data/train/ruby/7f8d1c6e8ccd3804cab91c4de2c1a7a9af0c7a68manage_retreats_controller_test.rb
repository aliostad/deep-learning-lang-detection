require 'test_helper'

class ManageRetreatsControllerTest < ActionController::TestCase
  setup do
    @manage_retreat = manage_retreats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_retreats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_retreat" do
    assert_difference('ManageRetreat.count') do
      post :create, manage_retreat: { created_by: @manage_retreat.created_by, desc: @manage_retreat.desc, image: @manage_retreat.image, sub_category: @manage_retreat.sub_category, title: @manage_retreat.title }
    end

    assert_redirected_to manage_retreat_path(assigns(:manage_retreat))
  end

  test "should show manage_retreat" do
    get :show, id: @manage_retreat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_retreat
    assert_response :success
  end

  test "should update manage_retreat" do
    patch :update, id: @manage_retreat, manage_retreat: { created_by: @manage_retreat.created_by, desc: @manage_retreat.desc, image: @manage_retreat.image, sub_category: @manage_retreat.sub_category, title: @manage_retreat.title }
    assert_redirected_to manage_retreat_path(assigns(:manage_retreat))
  end

  test "should destroy manage_retreat" do
    assert_difference('ManageRetreat.count', -1) do
      delete :destroy, id: @manage_retreat
    end

    assert_redirected_to manage_retreats_path
  end
end
