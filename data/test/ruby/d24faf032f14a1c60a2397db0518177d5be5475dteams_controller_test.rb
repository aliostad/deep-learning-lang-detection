require 'test_helper'

class Api::TeamsControllerTest < ActionController::TestCase
  setup do
    @api_team = api_teams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_team" do
    assert_difference('Api::Team.count') do
      post :create, api_team: {  }
    end

    assert_redirected_to api_team_path(assigns(:api_team))
  end

  test "should show api_team" do
    get :show, id: @api_team
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_team
    assert_response :success
  end

  test "should update api_team" do
    patch :update, id: @api_team, api_team: {  }
    assert_redirected_to api_team_path(assigns(:api_team))
  end

  test "should destroy api_team" do
    assert_difference('Api::Team.count', -1) do
      delete :destroy, id: @api_team
    end

    assert_redirected_to api_teams_path
  end
end
