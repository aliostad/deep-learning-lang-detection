require 'test_helper'

class Api::PostsControllerTest < ActionController::TestCase
  setup do
    @api_post = api_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_post" do
    assert_difference('Api::Post.count') do
      post :create, api_post: {  }
    end

    assert_redirected_to api_post_path(assigns(:api_post))
  end

  test "should show api_post" do
    get :show, id: @api_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_post
    assert_response :success
  end

  test "should update api_post" do
    patch :update, id: @api_post, api_post: {  }
    assert_redirected_to api_post_path(assigns(:api_post))
  end

  test "should destroy api_post" do
    assert_difference('Api::Post.count', -1) do
      delete :destroy, id: @api_post
    end

    assert_redirected_to api_posts_path
  end
end
