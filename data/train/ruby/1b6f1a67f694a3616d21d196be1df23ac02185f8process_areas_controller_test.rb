require 'test_helper'

class ProcessAreasControllerTest < ActionController::TestCase
  setup do
    @process_area = process_areas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_area" do
    assert_difference('ProcessArea.count') do
      post :create, process_area: { maturity_level_id: @process_area.maturity_level_id, name: @process_area.name, process_category_id: @process_area.process_category_id, purpose: @process_area.purpose }
    end

    assert_redirected_to process_area_path(assigns(:process_area))
  end

  test "should show process_area" do
    get :show, id: @process_area
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_area
    assert_response :success
  end

  test "should update process_area" do
    patch :update, id: @process_area, process_area: { maturity_level_id: @process_area.maturity_level_id, name: @process_area.name, process_category_id: @process_area.process_category_id, purpose: @process_area.purpose }
    assert_redirected_to process_area_path(assigns(:process_area))
  end

  test "should destroy process_area" do
    assert_difference('ProcessArea.count', -1) do
      delete :destroy, id: @process_area
    end

    assert_redirected_to process_areas_path
  end
end
