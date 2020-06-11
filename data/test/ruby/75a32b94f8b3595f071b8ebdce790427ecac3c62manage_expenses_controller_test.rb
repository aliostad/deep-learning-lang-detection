require 'test_helper'

class ManageExpensesControllerTest < ActionController::TestCase
  setup do
    @manage_expense = manage_expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manage_expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manage_expense" do
    assert_difference('ManageExpense.count') do
      post :create, manage_expense: { description: @manage_expense.description, divide_among: @manage_expense.divide_among, people_paid: @manage_expense.people_paid, title: @manage_expense.title, total_amount: @manage_expense.total_amount }
    end

    assert_redirected_to manage_expense_path(assigns(:manage_expense))
  end

  test "should show manage_expense" do
    get :show, id: @manage_expense
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manage_expense
    assert_response :success
  end

  test "should update manage_expense" do
    put :update, id: @manage_expense, manage_expense: { description: @manage_expense.description, divide_among: @manage_expense.divide_among, people_paid: @manage_expense.people_paid, title: @manage_expense.title, total_amount: @manage_expense.total_amount }
    assert_redirected_to manage_expense_path(assigns(:manage_expense))
  end

  test "should destroy manage_expense" do
    assert_difference('ManageExpense.count', -1) do
      delete :destroy, id: @manage_expense
    end

    assert_redirected_to manage_expenses_path
  end
end
