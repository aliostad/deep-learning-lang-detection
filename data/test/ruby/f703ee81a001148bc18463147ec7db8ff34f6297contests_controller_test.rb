require 'test_helper'

class Manage::ContestsControllerTest < ActionController::TestCase
  setup do
    @manage_contest = manage_contests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_contests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_contest" do
    assert_difference('Manage::Contest.count') do
      post :create, manage_contest: { description: @manage_contest.description, level: @manage_contest.level, name: @manage_contest.name, organizer: @manage_contest.organizer, summary: @manage_contest.summary }
    end

    assert_redirected_to manage_contest_path(assigns(:manage_contest))
  end

  test "should show manage_contest" do
    get :show, id: @manage_contest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_contest
    assert_response :success
  end

  test "should update manage_contest" do
    patch :update, id: @manage_contest, manage_contest: { description: @manage_contest.description, level: @manage_contest.level, name: @manage_contest.name, organizer: @manage_contest.organizer, summary: @manage_contest.summary }
    assert_redirected_to manage_contest_path(assigns(:manage_contest))
  end

  test "should destroy manage_contest" do
    assert_difference('Manage::Contest.count', -1) do
      delete :destroy, id: @manage_contest
    end

    assert_redirected_to manage_contests_path
  end
end
