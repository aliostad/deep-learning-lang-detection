require 'test_helper'

class ManageFollowUsControllerTest < ActionController::TestCase
  setup do
    @manage_follow_u = manage_follow_us(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_follow_us)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_follow_u" do
    assert_difference('ManageFollowU.count') do
      post :create, manage_follow_u: { facebook_url: @manage_follow_u.facebook_url, flickr_url: @manage_follow_u.flickr_url, google_url: @manage_follow_u.google_url, ping_url: @manage_follow_u.ping_url, rss_url: @manage_follow_u.rss_url, tumbir_url: @manage_follow_u.tumbir_url, twitter_url: @manage_follow_u.twitter_url, vimeo_url: @manage_follow_u.vimeo_url, youtube_url: @manage_follow_u.youtube_url }
    end

    assert_redirected_to manage_follow_u_path(assigns(:manage_follow_u))
  end

  test "should show manage_follow_u" do
    get :show, id: @manage_follow_u
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_follow_u
    assert_response :success
  end

  test "should update manage_follow_u" do
    patch :update, id: @manage_follow_u, manage_follow_u: { facebook_url: @manage_follow_u.facebook_url, flickr_url: @manage_follow_u.flickr_url, google_url: @manage_follow_u.google_url, ping_url: @manage_follow_u.ping_url, rss_url: @manage_follow_u.rss_url, tumbir_url: @manage_follow_u.tumbir_url, twitter_url: @manage_follow_u.twitter_url, vimeo_url: @manage_follow_u.vimeo_url, youtube_url: @manage_follow_u.youtube_url }
    assert_redirected_to manage_follow_u_path(assigns(:manage_follow_u))
  end

  test "should destroy manage_follow_u" do
    assert_difference('ManageFollowU.count', -1) do
      delete :destroy, id: @manage_follow_u
    end

    assert_redirected_to manage_follow_us_path
  end
end
