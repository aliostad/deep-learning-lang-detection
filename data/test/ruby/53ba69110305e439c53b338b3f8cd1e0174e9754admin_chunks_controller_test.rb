require 'test_helper'

class AdminChunksControllerTest < ActionController::TestCase
  setup do
    @admin_chunk = admin_chunks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_chunks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_chunk" do
    assert_difference('AdminChunk.count') do
      post :create, admin_chunk: {  }
    end

    assert_redirected_to admin_chunk_path(assigns(:admin_chunk))
  end

  test "should show admin_chunk" do
    get :show, id: @admin_chunk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_chunk
    assert_response :success
  end

  test "should update admin_chunk" do
    put :update, id: @admin_chunk, admin_chunk: {  }
    assert_redirected_to admin_chunk_path(assigns(:admin_chunk))
  end

  test "should destroy admin_chunk" do
    assert_difference('AdminChunk.count', -1) do
      delete :destroy, id: @admin_chunk
    end

    assert_redirected_to admin_chunks_path
  end
end
