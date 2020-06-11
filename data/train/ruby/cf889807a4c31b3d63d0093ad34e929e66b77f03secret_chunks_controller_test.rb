require 'test_helper'

class SecretChunksControllerTest < ActionController::TestCase
  setup do
    @secret_chunk = secret_chunks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:secret_chunks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create secret_chunk" do
    assert_difference('SecretChunk.count') do
      post :create, secret_chunk: { chunk_wall_id: @secret_chunk.chunk_wall_id, content: @secret_chunk.content, user_id: @secret_chunk.user_id }
    end

    assert_redirected_to secret_chunk_path(assigns(:secret_chunk))
  end

  test "should show secret_chunk" do
    get :show, id: @secret_chunk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @secret_chunk
    assert_response :success
  end

  test "should update secret_chunk" do
    patch :update, id: @secret_chunk, secret_chunk: { chunk_wall_id: @secret_chunk.chunk_wall_id, content: @secret_chunk.content, user_id: @secret_chunk.user_id }
    assert_redirected_to secret_chunk_path(assigns(:secret_chunk))
  end

  test "should destroy secret_chunk" do
    assert_difference('SecretChunk.count', -1) do
      delete :destroy, id: @secret_chunk
    end

    assert_redirected_to secret_chunks_path
  end
end
