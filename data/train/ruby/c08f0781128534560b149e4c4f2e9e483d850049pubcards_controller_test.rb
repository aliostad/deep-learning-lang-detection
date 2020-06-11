require 'test_helper'

class Manage::PubcardsControllerTest < ActionController::TestCase
  setup do
    @manage_pubcard = manage_pubcards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_pubcards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_pubcard" do
    assert_difference('Manage::Pubcard.count') do
      post :create, manage_pubcard: {  }
    end

    assert_redirected_to manage_pubcard_path(assigns(:manage_pubcard))
  end

  test "should show manage_pubcard" do
    get :show, id: @manage_pubcard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_pubcard
    assert_response :success
  end

  test "should update manage_pubcard" do
    patch :update, id: @manage_pubcard, manage_pubcard: {  }
    assert_redirected_to manage_pubcard_path(assigns(:manage_pubcard))
  end

  test "should destroy manage_pubcard" do
    assert_difference('Manage::Pubcard.count', -1) do
      delete :destroy, id: @manage_pubcard
    end

    assert_redirected_to manage_pubcards_path
  end
end
