require 'test_helper'

class ManageHealsControllerTest < ActionController::TestCase
  setup do
    @manage_heal = manage_heals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_heals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_heal" do
    assert_difference('ManageHeal.count') do
      post :create, manage_heal: { created_by: @manage_heal.created_by, desc: @manage_heal.desc, image: @manage_heal.image, sub_category: @manage_heal.sub_category, title: @manage_heal.title }
    end

    assert_redirected_to manage_heal_path(assigns(:manage_heal))
  end

  test "should show manage_heal" do
    get :show, id: @manage_heal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_heal
    assert_response :success
  end

  test "should update manage_heal" do
    patch :update, id: @manage_heal, manage_heal: { created_by: @manage_heal.created_by, desc: @manage_heal.desc, image: @manage_heal.image, sub_category: @manage_heal.sub_category, title: @manage_heal.title }
    assert_redirected_to manage_heal_path(assigns(:manage_heal))
  end

  test "should destroy manage_heal" do
    assert_difference('ManageHeal.count', -1) do
      delete :destroy, id: @manage_heal
    end

    assert_redirected_to manage_heals_path
  end
end
