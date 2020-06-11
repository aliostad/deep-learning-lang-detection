require 'test_helper'

class ManageDirectoriesControllerTest < ActionController::TestCase
  setup do
    @manage_directory = manage_directories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_directories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_directory" do
    assert_difference('ManageDirectory.count') do
      post :create, manage_directory: { business_name: @manage_directory.business_name, city: @manage_directory.city, country: @manage_directory.country, desc: @manage_directory.desc, email: @manage_directory.email, location: @manage_directory.location, phone_no: @manage_directory.phone_no, sub_category: @manage_directory.sub_category, website: @manage_directory.website }
    end

    assert_redirected_to manage_directory_path(assigns(:manage_directory))
  end

  test "should show manage_directory" do
    get :show, id: @manage_directory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_directory
    assert_response :success
  end

  test "should update manage_directory" do
    patch :update, id: @manage_directory, manage_directory: { business_name: @manage_directory.business_name, city: @manage_directory.city, country: @manage_directory.country, desc: @manage_directory.desc, email: @manage_directory.email, location: @manage_directory.location, phone_no: @manage_directory.phone_no, sub_category: @manage_directory.sub_category, website: @manage_directory.website }
    assert_redirected_to manage_directory_path(assigns(:manage_directory))
  end

  test "should destroy manage_directory" do
    assert_difference('ManageDirectory.count', -1) do
      delete :destroy, id: @manage_directory
    end

    assert_redirected_to manage_directories_path
  end
end
