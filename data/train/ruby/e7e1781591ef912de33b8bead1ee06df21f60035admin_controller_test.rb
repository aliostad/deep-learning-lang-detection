require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get manage" do
    get :manage
    assert_response :success
  end

  test "should get user_manage" do
    get :user_manage
    assert_response :success
  end

  test "should get post_manage" do
    get :post_manage
    assert_response :success
  end

  test "should get report" do
    get :report
    assert_response :success
  end

  test "should get feedback" do
    get :feedback
    assert_response :success
  end

end
