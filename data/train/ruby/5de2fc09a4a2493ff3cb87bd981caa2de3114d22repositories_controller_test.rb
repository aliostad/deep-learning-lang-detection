require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  setup do
    @repository = repositories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repositories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repository" do
    assert_difference('Repository.count') do
      post :create, repository: { address2: @repository.address2, address: @repository.address, administrator: @repository.administrator, city: @repository.city, code: @repository.code, country: @repository.country, email: @repository.email, email_signature: @repository.email_signature, fax: @repository.fax, name: @repository.name, phone: @repository.phone, phone_ext: @repository.phone_ext, research_functionality: @repository.research_functionality, state: @repository.state, url: @repository.url, zip: @repository.zip }
    end

    assert_redirected_to repository_path(assigns(:repository))
  end

  test "should show repository" do
    get :show, id: @repository
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @repository
    assert_response :success
  end

  test "should update repository" do
    put :update, id: @repository, repository: { address2: @repository.address2, address: @repository.address, administrator: @repository.administrator, city: @repository.city, code: @repository.code, country: @repository.country, email: @repository.email, email_signature: @repository.email_signature, fax: @repository.fax, name: @repository.name, phone: @repository.phone, phone_ext: @repository.phone_ext, research_functionality: @repository.research_functionality, state: @repository.state, url: @repository.url, zip: @repository.zip }
    assert_redirected_to repository_path(assigns(:repository))
  end

  test "should destroy repository" do
    assert_difference('Repository.count', -1) do
      delete :destroy, id: @repository
    end

    assert_redirected_to repositories_path
  end
end
