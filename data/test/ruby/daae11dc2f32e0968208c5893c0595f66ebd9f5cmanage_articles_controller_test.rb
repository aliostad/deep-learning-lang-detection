require 'test_helper'

class ManageArticlesControllerTest < ActionController::TestCase
  setup do
    @manage_article = manage_articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_article" do
    assert_difference('ManageArticle.count') do
      post :create, manage_article: { cat: @manage_article.cat, created_by: @manage_article.created_by, desc: @manage_article.desc, image: @manage_article.image, rel_article: @manage_article.rel_article, sub_cat: @manage_article.sub_cat, title: @manage_article.title }
    end

    assert_redirected_to manage_article_path(assigns(:manage_article))
  end

  test "should show manage_article" do
    get :show, id: @manage_article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_article
    assert_response :success
  end

  test "should update manage_article" do
    patch :update, id: @manage_article, manage_article: { cat: @manage_article.cat, created_by: @manage_article.created_by, desc: @manage_article.desc, image: @manage_article.image, rel_article: @manage_article.rel_article, sub_cat: @manage_article.sub_cat, title: @manage_article.title }
    assert_redirected_to manage_article_path(assigns(:manage_article))
  end

  test "should destroy manage_article" do
    assert_difference('ManageArticle.count', -1) do
      delete :destroy, id: @manage_article
    end

    assert_redirected_to manage_articles_path
  end
end
