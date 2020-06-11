require 'test_helper'

class ChunksControllerTest < ActionController::TestCase
  setup do
    @chunk = chunks(:one)
    @user = users(:one)
  end

  test "should get index" do
    sign_in :user, @user
    get :index, :book_id => @chunk.book
    assert_response :success
    assert_not_nil assigns(:chunks)
  end

  test "should get new" do
    sign_in :user, @user
    get :new, :book_id => @chunk.book.id
    assert_response :success
  end

  test "should create chunk" do
    sign_in :user, @user
    assert_difference('Chunk.count') do
      post :create, chunk: { content: @chunk.content, section: @chunk.section, title: @chunk.title }, book_id: @chunk.book.id
    end

    assert_redirected_to book_path(assigns(:book))
  end

  test "should show chunk" do
    sign_in :user, @user
    get :show, id: @chunk, :book_id => @chunk.book.id
    assert_response :success
  end

  test "should get edit" do
    sign_in :user, @user
    get :edit, id: @chunk, :book_id => @chunk.book.id
    assert_response :success
  end

  test "should destroy chunk" do
    sign_in :user, @user
    assert_difference('Chunk.count', -1) do
      delete :destroy, id: @chunk, book_id: @chunk.book.id
    end

    assert_redirected_to book_path
  end
end
