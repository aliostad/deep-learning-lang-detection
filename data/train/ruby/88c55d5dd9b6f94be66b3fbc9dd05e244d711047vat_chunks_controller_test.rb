require 'test_helper'

class VatChunksControllerTest < ActionController::TestCase
  setup do
    @vat_chunk = vat_chunks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vat_chunks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vat_chunk" do
    assert_difference('VatChunk.count') do
      post :create, :vat_chunk => @vat_chunk.attributes
    end

    assert_redirected_to vat_chunk_path(assigns(:vat_chunk))
  end

  test "should show vat_chunk" do
    get :show, :id => @vat_chunk.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vat_chunk.to_param
    assert_response :success
  end

  test "should update vat_chunk" do
    put :update, :id => @vat_chunk.to_param, :vat_chunk => @vat_chunk.attributes
    assert_redirected_to vat_chunk_path(assigns(:vat_chunk))
  end

  test "should destroy vat_chunk" do
    assert_difference('VatChunk.count', -1) do
      delete :destroy, :id => @vat_chunk.to_param
    end

    assert_redirected_to vat_chunks_path
  end
end
