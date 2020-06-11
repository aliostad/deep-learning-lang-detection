require 'test_helper'

class ApiSeasonsControllerTest < ActionController::TestCase
  setup do
    @api_season = api_seasons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_seasons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_season" do
    assert_difference('ApiSeason.count') do
      post :create, api_season: {  }
    end

    assert_redirected_to api_season_path(assigns(:api_season))
  end

  test "should show api_season" do
    get :show, id: @api_season
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_season
    assert_response :success
  end

  test "should update api_season" do
    patch :update, id: @api_season, api_season: {  }
    assert_redirected_to api_season_path(assigns(:api_season))
  end

  test "should destroy api_season" do
    assert_difference('ApiSeason.count', -1) do
      delete :destroy, id: @api_season
    end

    assert_redirected_to api_seasons_path
  end
end
