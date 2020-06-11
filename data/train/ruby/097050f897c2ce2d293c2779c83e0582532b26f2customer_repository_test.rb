require_relative '../test/test_helper'
require_relative '../lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test

  def test_it_starts_with_an_empty_array_of_customers
    customer_repository = CustomerRepository.new(nil)
    assert_equal [], customer_repository.customers
  end


  def test_it_can_load_data_to_customer
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")

    assert_equal "Joey", customer_repository.customers.first.first_name
    assert_equal 1, customer_repository.customers.first.id
    assert_equal "Stark", customer_repository.customers[50].last_name
  end

  def test_it_can_return_all_customers
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")

    assert_equal 1000, customer_repository.customers.count
  end

  def test_it_can_return_random_sample
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")

    assert customer_repository.random
  end

  def test_it_can_find_by_id
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_by_id(4)

    assert_equal 4, result.id
  end

  def test_it_can_find_by_first_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_by_first_name("joey")

    assert_equal "Joey", result.first_name
  end

  def test_it_can_find_by_last_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_by_last_name("nader")

    assert_equal "Nader", result.last_name
  end

  def test_it_can_find_by_created_at
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_by_created_at("2012-03-27 14:54:09 UTC")

    assert_equal "2012-03-27 14:54:09 UTC", result.created_at
  end

  def test_it_can_find_by_updated_at
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_by_updated_at("2012-03-27 14:54:11 UTC")

    assert_equal "2012-03-27 14:54:11 UTC", result.updated_at
  end

  def test_it_can_find_all_by_id
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_all_by_id(4)

    assert_equal 1, result.count
  end

  def test_it_can_find_all_by_first_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_all_by_first_name("mary")

    assert_equal 1, result.count
  end

  def test_it_can_find_all_by_last_name
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_all_by_last_name("luettgen")

    assert_equal 6, result.count
  end

  def test_it_can_find_all_by_created_at
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_all_by_created_at("2012-03-27 14:54:17 UTC")

    assert_equal 3, result.count
  end

  def test_it_can_find_all_by_updated_at
    customer_repository = CustomerRepository.new(nil)
    customer_repository.load_data("./data/customers.csv")
    result = customer_repository.find_all_by_updated_at("2012-03-27 14:54:17 UTC")

    assert_equal 3, result.count
  end

  def test_it_can_talk_to_the_parent_with_invoice
    parent = Minitest::Mock.new
    customer_repository = CustomerRepository.new(parent)
    parent.expect(:find_invoices_by_customer_id, "pizza", [1])

    assert_equal "pizza", customer_repository.find_invoices(1)
    parent.verify
  end
end
