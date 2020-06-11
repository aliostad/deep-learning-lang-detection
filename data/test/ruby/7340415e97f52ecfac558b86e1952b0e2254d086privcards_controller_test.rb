require 'test_helper'

class Manage::PrivcardsControllerTest < ActionController::TestCase
  setup do
    @manage_privcard = manage_privcards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_privcards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_privcard" do
    assert_difference('Manage::Privcard.count') do
      post :create, manage_privcard: {  }
    end

    assert_redirected_to manage_privcard_path(assigns(:manage_privcard))
  end

  test "should show manage_privcard" do
    get :show, id: @manage_privcard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_privcard
    assert_response :success
  end

  test "should update manage_privcard" do
    patch :update, id: @manage_privcard, manage_privcard: {  }
    assert_redirected_to manage_privcard_path(assigns(:manage_privcard))
  end

  test "should destroy manage_privcard" do
    assert_difference('Manage::Privcard.count', -1) do
      delete :destroy, id: @manage_privcard
    end

    assert_redirected_to manage_privcards_path
  end
end
