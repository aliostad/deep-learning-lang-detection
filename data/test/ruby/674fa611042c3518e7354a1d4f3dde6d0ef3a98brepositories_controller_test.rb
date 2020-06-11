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
      post :create, repository: { feed_hits: @repository.feed_hits, first_created: @repository.first_created, forks: @repository.forks, gemfile_contents: @repository.gemfile_contents, has_gemfile: @repository.has_gemfile, last_checked: @repository.last_checked, last_created: @repository.last_created, last_push: @repository.last_push, owner_name: @repository.owner_name, repo_size: @repository.repo_size, repository_created: @repository.repository_created, repository_url: @repository.repository_url, watchers: @repository.watchers }
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
    patch :update, id: @repository, repository: { feed_hits: @repository.feed_hits, first_created: @repository.first_created, forks: @repository.forks, gemfile_contents: @repository.gemfile_contents, has_gemfile: @repository.has_gemfile, last_checked: @repository.last_checked, last_created: @repository.last_created, last_push: @repository.last_push, owner_name: @repository.owner_name, repo_size: @repository.repo_size, repository_created: @repository.repository_created, repository_url: @repository.repository_url, watchers: @repository.watchers }
    assert_redirected_to repository_path(assigns(:repository))
  end

  test "should destroy repository" do
    assert_difference('Repository.count', -1) do
      delete :destroy, id: @repository
    end

    assert_redirected_to repositories_path
  end
end
