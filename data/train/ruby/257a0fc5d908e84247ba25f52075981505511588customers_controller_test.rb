require 'test_helper'

class Api::CustomersControllerTest < ActionController::TestCase
  setup do
    @api_customer = api_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_customers)
  end

  test "should create api_customer" do
    assert_difference('Api::Customer.count') do
      post :create, api_customer: { address1: @api_customer.address1, address2: @api_customer.address2, city: @api_customer.city, email: @api_customer.email, first_name: @api_customer.first_name, last_name: @api_customer.last_name, phone: @api_customer.phone, price: @api_customer.price, ssid: @api_customer.ssid, state: @api_customer.state, zip: @api_customer.zip }
    end

    assert_response 201
  end

  test "should show api_customer" do
    get :show, id: @api_customer
    assert_response :success
  end

  test "should update api_customer" do
    put :update, id: @api_customer, api_customer: { address1: @api_customer.address1, address2: @api_customer.address2, city: @api_customer.city, email: @api_customer.email, first_name: @api_customer.first_name, last_name: @api_customer.last_name, phone: @api_customer.phone, price: @api_customer.price, ssid: @api_customer.ssid, state: @api_customer.state, zip: @api_customer.zip }
    assert_response 204
  end

  test "should destroy api_customer" do
    assert_difference('Api::Customer.count', -1) do
      delete :destroy, id: @api_customer
    end

    assert_response 204
  end
end
