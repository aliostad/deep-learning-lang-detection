require 'test_helper'

class ManageGlowsControllerTest < ActionController::TestCase
  setup do
    @manage_glow = manage_glows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_glows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_glow" do
    assert_difference('ManageGlow.count') do
      post :create, manage_glow: { created_by: @manage_glow.created_by, desc: @manage_glow.desc, image: @manage_glow.image, sub_category: @manage_glow.sub_category, title: @manage_glow.title }
    end

    assert_redirected_to manage_glow_path(assigns(:manage_glow))
  end

  test "should show manage_glow" do
    get :show, id: @manage_glow
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_glow
    assert_response :success
  end

  test "should update manage_glow" do
    patch :update, id: @manage_glow, manage_glow: { created_by: @manage_glow.created_by, desc: @manage_glow.desc, image: @manage_glow.image, sub_category: @manage_glow.sub_category, title: @manage_glow.title }
    assert_redirected_to manage_glow_path(assigns(:manage_glow))
  end

  test "should destroy manage_glow" do
    assert_difference('ManageGlow.count', -1) do
      delete :destroy, id: @manage_glow
    end

    assert_redirected_to manage_glows_path
  end
end
