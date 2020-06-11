require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "the has list" do
    apiKey = api_keys(:one)
    apiKey.list_id = nil
    assert_not apiKey.save
  end
  
  test "the share has email" do
    apiKey = api_keys(:one)
    apiKey.owner = false
    apiKey.email = nil
    assert_not apiKey.save
  end
  
  test "the has an invalid email" do
    apiKey = api_keys(:one)
    apiKey.owner = false
    apiKey.email = 'adfffa.dfa.ds'
    assert_not apiKey.save
  end
  
  test "the has owner" do
    apiKey = api_keys(:one)
    apiKey.owner = nil
    assert_not apiKey.save
  end

  test "create a new api key" do
    apiKey = ApiKey.new
    apiKey.list = lists(:one)
    apiKey.email = 'dani_vela@me.com'
    apiKey.owner = true
    assert apiKey.save
  end
  
end
