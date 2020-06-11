require 'test_helper'

class ManagePosesControllerTest < ActionController::TestCase
  setup do
    @manage_pose = manage_poses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_poses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_pose" do
    assert_difference('ManagePose.count') do
      post :create, manage_pose: { author: @manage_pose.author, desc: @manage_pose.desc, pose_image: @manage_pose.pose_image, sub_category: @manage_pose.sub_category, title: @manage_pose.title }
    end

    assert_redirected_to manage_pose_path(assigns(:manage_pose))
  end

  test "should show manage_pose" do
    get :show, id: @manage_pose
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_pose
    assert_response :success
  end

  test "should update manage_pose" do
    patch :update, id: @manage_pose, manage_pose: { author: @manage_pose.author, desc: @manage_pose.desc, pose_image: @manage_pose.pose_image, sub_category: @manage_pose.sub_category, title: @manage_pose.title }
    assert_redirected_to manage_pose_path(assigns(:manage_pose))
  end

  test "should destroy manage_pose" do
    assert_difference('ManagePose.count', -1) do
      delete :destroy, id: @manage_pose
    end

    assert_redirected_to manage_poses_path
  end
end
