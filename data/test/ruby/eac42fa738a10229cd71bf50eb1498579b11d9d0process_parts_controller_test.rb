require 'test_helper'

class ProcessPartsControllerTest < ActionController::TestCase
  setup do
    @process_part = process_parts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_parts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_part" do
    assert_difference('ProcessPart.count') do
      post :create, process_part: { part_id: @process_part.part_id, process_entity_id: @process_part.process_entity_id, quantity: @process_part.quantity, unit: @process_part.unit }
    end

    assert_redirected_to process_part_path(assigns(:process_part))
  end

  test "should show process_part" do
    get :show, id: @process_part
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_part
    assert_response :success
  end

  test "should update process_part" do
    patch :update, id: @process_part, process_part: { part_id: @process_part.part_id, process_entity_id: @process_part.process_entity_id, quantity: @process_part.quantity, unit: @process_part.unit }
    assert_redirected_to process_part_path(assigns(:process_part))
  end

  test "should destroy process_part" do
    assert_difference('ProcessPart.count', -1) do
      delete :destroy, id: @process_part
    end

    assert_redirected_to process_parts_path
  end
end
