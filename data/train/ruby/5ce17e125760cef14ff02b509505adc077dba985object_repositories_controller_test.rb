require 'test_helper'

class ObjectRepositoriesControllerTest < ActionController::TestCase
  setup do
    @object_repository = object_repositories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:object_repositories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create object_repository" do
    assert_difference('ObjectRepository.count') do
      post :create, object_repository: { element_name: @object_repository.element_name, identifier_name: @object_repository.identifier_name, identifier_value: @object_repository.identifier_value, page_name: @object_repository.page_name, type: @object_repository.type }
    end

    assert_redirected_to object_repository_path(assigns(:object_repository))
  end

  test "should show object_repository" do
    get :show, id: @object_repository
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @object_repository
    assert_response :success
  end

  test "should update object_repository" do
    patch :update, id: @object_repository, object_repository: { element_name: @object_repository.element_name, identifier_name: @object_repository.identifier_name, identifier_value: @object_repository.identifier_value, page_name: @object_repository.page_name, type: @object_repository.type }
    assert_redirected_to object_repository_path(assigns(:object_repository))
  end

  test "should destroy object_repository" do
    assert_difference('ObjectRepository.count', -1) do
      delete :destroy, id: @object_repository
    end

    assert_redirected_to object_repositories_path
  end
end
