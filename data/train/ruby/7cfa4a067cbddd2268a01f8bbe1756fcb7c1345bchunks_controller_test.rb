require 'test_helper'
require 'authlogic/test_case'

class ChunksControllerTest < ActionController::TestCase
  setup :activate_authlogic

  setup do
    @chunk = chunks(:one)
    UserSession.create(users(:one))
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chunks)
    assert assigns(:chunks).is_a?(Array)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:works)
  end

  test "should create chunk" do
    assert_difference('Chunk.count') do
      post :create, :chunk => @chunk.attributes
    end

    assert_redirected_to chunk_path(assigns(:chunk))
  end

  test "should show chunk" do
    get :show, :id => @chunk.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @chunk.to_param
    assert_response :success
    assert_not_nil assigns(:works)
  end

  test "should update chunk" do
    put :update, :id => @chunk.to_param, :chunk => @chunk.attributes
    assert_redirected_to chunk_path(assigns(:chunk))
  end

  test "should destroy chunk" do
    assert_difference('Chunk.count', -1) do
      delete :destroy, :id => @chunk.to_param
    end

    assert_redirected_to chunks_path
  end

  test "should not get if not logged in" do
    UserSession.find.destroy
    get :index
    assert_redirected_to user_session_login_url
    [:edit, :show]. each do |m|
      get m, :id => @chunk.to_param
      assert_redirected_to user_session_login_url
    end
    delete :destroy, :id => @chunk.to_param
    assert_redirected_to user_session_login_url
    put :update, :id => @chunk.to_param, :chunk => @chunk.attributes
    assert_redirected_to user_session_login_url
  end
end
