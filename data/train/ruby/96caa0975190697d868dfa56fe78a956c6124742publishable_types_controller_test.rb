require 'test_helper'

module Publinator
  class Manage::PublishableTypesControllerTest < ActionController::TestCase
    setup do
      @manage_publishable_type = manage_publishable_types(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:manage_publishable_types)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create manage_publishable_type" do
      assert_difference('Manage::PublishableType.count') do
        post :create, manage_publishable_type: {  }
      end
  
      assert_redirected_to manage_publishable_type_path(assigns(:manage_publishable_type))
    end
  
    test "should show manage_publishable_type" do
      get :show, id: @manage_publishable_type
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @manage_publishable_type
      assert_response :success
    end
  
    test "should update manage_publishable_type" do
      put :update, id: @manage_publishable_type, manage_publishable_type: {  }
      assert_redirected_to manage_publishable_type_path(assigns(:manage_publishable_type))
    end
  
    test "should destroy manage_publishable_type" do
      assert_difference('Manage::PublishableType.count', -1) do
        delete :destroy, id: @manage_publishable_type
      end
  
      assert_redirected_to manage_publishable_types_path
    end
  end
end
