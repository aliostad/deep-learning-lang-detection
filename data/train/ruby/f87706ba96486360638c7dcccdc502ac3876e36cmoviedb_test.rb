require 'test_helper'

class MovieDBTest < Test::Unit::TestCase
  
  should "accept MOVIEDB_API_KEY in environment" do
    ENV['MOVIEDB_API_KEY'] = '1234'
    assert_equal '1234', MovieDB.api_key
  end
  
  should "allow user to set api key" do
    MovieDB.api_key = '123'
    assert_equal '123', MovieDB.api_key
  end
  
  should "accept user api key over ENV api key" do
      MovieDB.api_key = '123'
      ENV['MOVIEDB_API_KEY'] = '234'
      assert_equal '123', MovieDB.api_key
  end
  
  
end