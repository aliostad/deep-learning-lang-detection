gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :merchant_repository#, :sales_engine

  def setup
    #@sales_engine = SalesEngine.new
    @merchant_repository = MerchantRepository.new(nil, "./fixtures/merchants_testdata.csv")
    merchant_repository.load_file
  end

  def test_it_can_find_all
    assert_equal 20, merchant_repository.all.length
  end

  def test_it_can_find_random
    assert merchant_repository.random
  end
end
