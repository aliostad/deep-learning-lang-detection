require 'test_helper'

class ProcessEntitiesControllerTest < ActionController::TestCase
  setup do
    @process_entity = process_entities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_entities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_entity" do
    assert_difference('ProcessEntity.count') do
      post :create, process_entity: { comment: @process_entity.comment, label: @process_entity.label, service_system_id: @process_entity.service_system_id, sid: @process_entity.sid }
    end

    assert_redirected_to process_entity_path(assigns(:process_entity))
  end

  test "should show process_entity" do
    get :show, id: @process_entity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_entity
    assert_response :success
  end

  test "should update process_entity" do
    put :update, id: @process_entity, process_entity: { comment: @process_entity.comment, label: @process_entity.label, service_system_id: @process_entity.service_system_id, sid: @process_entity.sid }
    assert_redirected_to process_entity_path(assigns(:process_entity))
  end

  test "should destroy process_entity" do
    assert_difference('ProcessEntity.count', -1) do
      delete :destroy, id: @process_entity
    end

    assert_redirected_to process_entities_path
  end
end
