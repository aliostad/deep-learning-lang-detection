require 'test_helper'

class Manage::NewsControllerTest < ActionController::TestCase
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
    assert_difference('Manage::News.count') do
      post :create, manage_news: { author: @manage_news.author, content: @manage_news.content, is_draft: @manage_news.is_draft, publish_at: @manage_news.publish_at, pure_content: @manage_news.pure_content, title: @manage_news.title }
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
    patch :update, id: @manage_news, manage_news: { author: @manage_news.author, content: @manage_news.content, is_draft: @manage_news.is_draft, publish_at: @manage_news.publish_at, pure_content: @manage_news.pure_content, title: @manage_news.title }
    assert_redirected_to manage_news_path(assigns(:manage_news))
  end

  test "should destroy manage_news" do
    assert_difference('Manage::News.count', -1) do
      delete :destroy, id: @manage_news
    end

    assert_redirected_to manage_news_index_path
  end
end
