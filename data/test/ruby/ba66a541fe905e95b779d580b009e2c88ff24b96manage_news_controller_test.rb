require 'test_helper'

class ManageNewsControllerTest < ActionController::TestCase
  setup do
    @manage_news = manage_news(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_news)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_news" do
    assert_difference('ManageNews.count') do
      post :create, manage_news: { created_by: @manage_news.created_by, desc: @manage_news.desc, news_image: @manage_news.news_image, title: @manage_news.title }
    end

    assert_redirected_to manage_news_path(assigns(:manage_news))
  end

  test "should show manage_news" do
    get :show, id: @manage_news
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_news
    assert_response :success
  end

  test "should update manage_news" do
    patch :update, id: @manage_news, manage_news: { created_by: @manage_news.created_by, desc: @manage_news.desc, news_image: @manage_news.news_image, title: @manage_news.title }
    assert_redirected_to manage_news_path(assigns(:manage_news))
  end

  test "should destroy manage_news" do
    assert_difference('ManageNews.count', -1) do
      delete :destroy, id: @manage_news
    end

    assert_redirected_to manage_news_index_path
  end
end
