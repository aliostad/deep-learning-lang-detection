require 'test_helper'

class Manage::ProfessionsControllerTest < ActionController::TestCase
  setup do
    @manage_profession = manage_professions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_professions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_profession" do
    assert_difference('Manage::Profession.count') do
      post :create, manage_profession: { name: @manage_profession.name }
    end

    assert_redirected_to manage_profession_path(assigns(:manage_profession))
  end

  test "should show manage_profession" do
    get :show, id: @manage_profession
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_profession
    assert_response :success
  end

  test "should update manage_profession" do
    patch :update, id: @manage_profession, manage_profession: { name: @manage_profession.name }
    assert_redirected_to manage_profession_path(assigns(:manage_profession))
  end

  test "should destroy manage_profession" do
    assert_difference('Manage::Profession.count', -1) do
      delete :destroy, id: @manage_profession
    end

    assert_redirected_to manage_professions_path
  end
end
