require 'test_helper'

class ManageNourishesControllerTest < ActionController::TestCase
  setup do
    @manage_nourish = manage_nourishes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_nourishes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_nourish" do
    assert_difference('ManageNourish.count') do
      post :create, manage_nourish: { created_by: @manage_nourish.created_by, desc: @manage_nourish.desc, image: @manage_nourish.image, sub_category: @manage_nourish.sub_category, title: @manage_nourish.title, website: @manage_nourish.website }
    end

    assert_redirected_to manage_nourish_path(assigns(:manage_nourish))
  end

  test "should show manage_nourish" do
    get :show, id: @manage_nourish
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_nourish
    assert_response :success
  end

  test "should update manage_nourish" do
    patch :update, id: @manage_nourish, manage_nourish: { created_by: @manage_nourish.created_by, desc: @manage_nourish.desc, image: @manage_nourish.image, sub_category: @manage_nourish.sub_category, title: @manage_nourish.title, website: @manage_nourish.website }
    assert_redirected_to manage_nourish_path(assigns(:manage_nourish))
  end

  test "should destroy manage_nourish" do
    assert_difference('ManageNourish.count', -1) do
      delete :destroy, id: @manage_nourish
    end

    assert_redirected_to manage_nourishes_path
  end
end
