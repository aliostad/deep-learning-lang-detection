require 'test_helper'

class Api::BenchmarksControllerTest < ActionController::TestCase
  setup do
    @api_benchmark = api_benchmarks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_benchmarks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_benchmark" do
    assert_difference('Api::Benchmark.count') do
      post :create, api_benchmark: {  }
    end

    assert_redirected_to api_benchmark_path(assigns(:api_benchmark))
  end

  test "should show api_benchmark" do
    get :show, id: @api_benchmark
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_benchmark
    assert_response :success
  end

  test "should update api_benchmark" do
    patch :update, id: @api_benchmark, api_benchmark: {  }
    assert_redirected_to api_benchmark_path(assigns(:api_benchmark))
  end

  test "should destroy api_benchmark" do
    assert_difference('Api::Benchmark.count', -1) do
      delete :destroy, id: @api_benchmark
    end

    assert_redirected_to api_benchmarks_path
  end
end
