require 'test_helper'

class Manage::MusicsControllerTest < ActionController::TestCase
  setup do
    @manage_music = manage_musics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_musics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_music" do
    assert_difference('Manage::Music.count') do
      post :create, manage_music: @manage_music.attributes
    end

    assert_redirected_to manage_music_path(assigns(:manage_music))
  end

  test "should show manage_music" do
    get :show, id: @manage_music.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_music.to_param
    assert_response :success
  end

  test "should update manage_music" do
    put :update, id: @manage_music.to_param, manage_music: @manage_music.attributes
    assert_redirected_to manage_music_path(assigns(:manage_music))
  end

  test "should destroy manage_music" do
    assert_difference('Manage::Music.count', -1) do
      delete :destroy, id: @manage_music.to_param
    end

    assert_redirected_to manage_musics_path
  end
end
