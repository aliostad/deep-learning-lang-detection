require 'test_helper'

class ProcessTemplatesControllerTest < ActionController::TestCase
  setup do
    @process_template = process_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_template" do
    assert_difference('ProcessTemplate.count') do
      post :create, process_template: { code: @process_template.code, description: @process_template.description, name: @process_template.name, template: @process_template.template, type: @process_template.type }
    end

    assert_redirected_to process_template_path(assigns(:process_template))
  end

  test "should show process_template" do
    get :show, id: @process_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_template
    assert_response :success
  end

  test "should update process_template" do
    patch :update, id: @process_template, process_template: { code: @process_template.code, description: @process_template.description, name: @process_template.name, template: @process_template.template, type: @process_template.type }
    assert_redirected_to process_template_path(assigns(:process_template))
  end

  test "should destroy process_template" do
    assert_difference('ProcessTemplate.count', -1) do
      delete :destroy, id: @process_template
    end

    assert_redirected_to process_templates_path
  end
end
