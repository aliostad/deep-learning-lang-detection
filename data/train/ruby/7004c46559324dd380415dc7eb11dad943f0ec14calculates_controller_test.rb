require 'test_helper'

class CalculatesControllerTest < ActionController::TestCase
  setup do
    @calculate = calculates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:calculates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create calculate" do
    assert_difference('Calculate.count') do
      post :create, calculate: { money_spent: @calculate.money_spent, name: @calculate.name }
    end

    assert_redirected_to calculate_path(assigns(:calculate))
  end

  test "should show calculate" do
    get :show, id: @calculate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @calculate
    assert_response :success
  end

  test "should update calculate" do
    patch :update, id: @calculate, calculate: { money_spent: @calculate.money_spent, name: @calculate.name }
    assert_redirected_to calculate_path(assigns(:calculate))
  end

  test "should destroy calculate" do
    assert_difference('Calculate.count', -1) do
      delete :destroy, id: @calculate
    end

    assert_redirected_to calculates_path
  end
end
