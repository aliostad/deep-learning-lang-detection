require 'test_helper'

class KanbanProcessEntitiesControllerTest < ActionController::TestCase
  setup do
    @kanban_process_entity = kanban_process_entities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kanban_process_entities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kanban_process_entity" do
    assert_difference('KanbanProcessEntity.count') do
      post :create, kanban_process_entity: { Kanban_id: @kanban_process_entity.Kanban_id, ProcessEntity_id: @kanban_process_entity.ProcessEntity_id }
    end

    assert_redirected_to kanban_process_entity_path(assigns(:kanban_process_entity))
  end

  test "should show kanban_process_entity" do
    get :show, id: @kanban_process_entity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kanban_process_entity
    assert_response :success
  end

  test "should update kanban_process_entity" do
    patch :update, id: @kanban_process_entity, kanban_process_entity: { Kanban_id: @kanban_process_entity.Kanban_id, ProcessEntity_id: @kanban_process_entity.ProcessEntity_id }
    assert_redirected_to kanban_process_entity_path(assigns(:kanban_process_entity))
  end

  test "should destroy kanban_process_entity" do
    assert_difference('KanbanProcessEntity.count', -1) do
      delete :destroy, id: @kanban_process_entity
    end

    assert_redirected_to kanban_process_entities_path
  end
end
