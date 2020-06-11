require 'test_helper'

class CalculatePaysControllerTest < ActionController::TestCase
  setup do
    @calculate_pay = calculate_pays(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calculate_pays)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create calculate_pay" do
    assert_difference('CalculatePay.count') do
      post :create, calculate_pay: { emp_id: @calculate_pay.emp_id, pay: @calculate_pay.pay }
    end

    assert_redirected_to calculate_pay_path(assigns(:calculate_pay))
  end

  test "should show calculate_pay" do
    get :show, id: @calculate_pay
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @calculate_pay
    assert_response :success
  end

  test "should update calculate_pay" do
    patch :update, id: @calculate_pay, calculate_pay: { emp_id: @calculate_pay.emp_id, pay: @calculate_pay.pay }
    assert_redirected_to calculate_pay_path(assigns(:calculate_pay))
  end

  test "should destroy calculate_pay" do
    assert_difference('CalculatePay.count', -1) do
      delete :destroy, id: @calculate_pay
    end

    assert_redirected_to calculate_pays_path
  end
end
