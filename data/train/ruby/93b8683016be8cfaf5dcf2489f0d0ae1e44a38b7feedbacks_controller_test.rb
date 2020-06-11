require 'test_helper'

class Api::FeedbacksControllerTest < ActionController::TestCase
  setup do
    @api_feedback = api_feedbacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_feedbacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_feedback" do
    assert_difference('Api::Feedback.count') do
      post :create, api_feedback: {  }
    end

    assert_redirected_to api_feedback_path(assigns(:api_feedback))
  end

  test "should show api_feedback" do
    get :show, id: @api_feedback
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_feedback
    assert_response :success
  end

  test "should update api_feedback" do
    patch :update, id: @api_feedback, api_feedback: {  }
    assert_redirected_to api_feedback_path(assigns(:api_feedback))
  end

  test "should destroy api_feedback" do
    assert_difference('Api::Feedback.count', -1) do
      delete :destroy, id: @api_feedback
    end

    assert_redirected_to api_feedbacks_path
  end
end
