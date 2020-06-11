require 'test_helper'

class StoryChunksControllerTest < ActionController::TestCase
  setup do
    @story_chunk = story_chunks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:story_chunks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create story_chunk" do
    assert_difference('StoryChunk.count') do
      post :create, story_chunk: { chunk_content: @story_chunk.chunk_content, chunk_number: @story_chunk.chunk_number, story_block_id: @story_chunk.story_block_id, user_id: @story_chunk.user_id }
    end

    assert_redirected_to story_chunk_path(assigns(:story_chunk))
  end

  test "should show story_chunk" do
    get :show, id: @story_chunk
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @story_chunk
    assert_response :success
  end

  test "should update story_chunk" do
    patch :update, id: @story_chunk, story_chunk: { chunk_content: @story_chunk.chunk_content, chunk_number: @story_chunk.chunk_number, story_block_id: @story_chunk.story_block_id, user_id: @story_chunk.user_id }
    assert_redirected_to story_chunk_path(assigns(:story_chunk))
  end

  test "should destroy story_chunk" do
    assert_difference('StoryChunk.count', -1) do
      delete :destroy, id: @story_chunk
    end

    assert_redirected_to story_chunks_path
  end
end
