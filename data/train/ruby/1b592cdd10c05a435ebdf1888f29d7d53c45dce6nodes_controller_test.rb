require 'test_helper'

class Manage::NodesControllerTest < ActionController::TestCase
  setup do
    @manage_node = manage_nodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_nodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_node" do
    assert_difference('Manage::Node.count') do
      post :create, manage_node: { extra_data: @manage_node.extra_data, name: @manage_node.name, pid: @manage_node.pid, remark: @manage_node.remark, sort: @manage_node.sort, title: @manage_node.title }
    end

    assert_redirected_to manage_node_path(assigns(:manage_node))
  end

  test "should show manage_node" do
    get :show, id: @manage_node
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_node
    assert_response :success
  end

  test "should update manage_node" do
    patch :update, id: @manage_node, manage_node: { extra_data: @manage_node.extra_data, name: @manage_node.name, pid: @manage_node.pid, remark: @manage_node.remark, sort: @manage_node.sort, title: @manage_node.title }
    assert_redirected_to manage_node_path(assigns(:manage_node))
  end

  test "should destroy manage_node" do
    assert_difference('Manage::Node.count', -1) do
      delete :destroy, id: @manage_node
    end

    assert_redirected_to manage_nodes_path
  end
end
