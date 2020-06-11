require 'test_helper'

class ManageTeamsControllerTest < ActionController::TestCase
  setup do
    @manage_team = manage_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_team" do
    assert_difference('ManageTeam.count') do
      post :create, manage_team: { desc: @manage_team.desc, image: @manage_team.image, name: @manage_team.name, position: @manage_team.position }
    end

    assert_redirected_to manage_team_path(assigns(:manage_team))
  end

  test "should show manage_team" do
    get :show, id: @manage_team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_team
    assert_response :success
  end

  test "should update manage_team" do
    patch :update, id: @manage_team, manage_team: { desc: @manage_team.desc, image: @manage_team.image, name: @manage_team.name, position: @manage_team.position }
    assert_redirected_to manage_team_path(assigns(:manage_team))
  end

  test "should destroy manage_team" do
    assert_difference('ManageTeam.count', -1) do
      delete :destroy, id: @manage_team
    end

    assert_redirected_to manage_teams_path
  end
end
