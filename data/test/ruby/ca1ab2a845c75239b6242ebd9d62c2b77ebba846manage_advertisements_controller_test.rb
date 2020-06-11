require 'test_helper'

class ManageAdvertisementsControllerTest < ActionController::TestCase
  setup do
    @manage_advertisement = manage_advertisements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_advertisements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_advertisement" do
    assert_difference('ManageAdvertisement.count') do
      post :create, manage_advertisement: { mid_add_image: @manage_advertisement.mid_add_image, mid_url: @manage_advertisement.mid_url, right_add_image: @manage_advertisement.right_add_image, right_url: @manage_advertisement.right_url }
    end

    assert_redirected_to manage_advertisement_path(assigns(:manage_advertisement))
  end

  test "should show manage_advertisement" do
    get :show, id: @manage_advertisement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_advertisement
    assert_response :success
  end

  test "should update manage_advertisement" do
    patch :update, id: @manage_advertisement, manage_advertisement: { mid_add_image: @manage_advertisement.mid_add_image, mid_url: @manage_advertisement.mid_url, right_add_image: @manage_advertisement.right_add_image, right_url: @manage_advertisement.right_url }
    assert_redirected_to manage_advertisement_path(assigns(:manage_advertisement))
  end

  test "should destroy manage_advertisement" do
    assert_difference('ManageAdvertisement.count', -1) do
      delete :destroy, id: @manage_advertisement
    end

    assert_redirected_to manage_advertisements_path
  end
end
