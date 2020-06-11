require 'test_helper'

class ManageContactsControllerTest < ActionController::TestCase
  setup do
    @manage_contact = manage_contacts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_contact" do
    assert_difference('ManageContact.count') do
      post :create, manage_contact: {  }
    end

    assert_redirected_to manage_contact_path(assigns(:manage_contact))
  end

  test "should show manage_contact" do
    get :show, id: @manage_contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_contact
    assert_response :success
  end

  test "should update manage_contact" do
    put :update, id: @manage_contact, manage_contact: {  }
    assert_redirected_to manage_contact_path(assigns(:manage_contact))
  end

  test "should destroy manage_contact" do
    assert_difference('ManageContact.count', -1) do
      delete :destroy, id: @manage_contact
    end

    assert_redirected_to manage_contacts_path
  end
end
