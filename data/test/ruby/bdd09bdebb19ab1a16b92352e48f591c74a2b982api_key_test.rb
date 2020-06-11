require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase

  def valid_api_key? key
    key.length == 40
  end

  test "should create valid api key" do
    api_key = ApiKey.new(:email => "hannotaatiouser@futurice.com")
    api_key.save
    assert valid_api_key? api_key.api_key
  end
  
  test "shouldn't create api key without valid email" do
    # Test without email
    api_key = ApiKey.new
    assert !api_key.save
    
    # Test valid email
    api_key = ApiKey.new(:email => "hannotaatiouser@futurice.com")
    assert api_key.save
        
    # Test invalid email
    api_key = ApiKey.new(:email => "hannotaatiouser@futurice@futurice.com.com")
    assert !api_key.save
  end
  
  test "should remove associated annotations if api key is removed" do
    Annotation.delete_all
    ApiKey.delete_all
    
    api_key = ApiKey.new(:email => "apikeyemail@invalid.com")
    assert api_key.save
    
    annotation = Annotation.new(:api_key => api_key);
    assert annotation.save
    
    assert_equal 1, Annotation.count
    assert_equal 1, ApiKey.count
    
    assert api_key.destroy
    
    assert_equal 0, Annotation.count
    assert_equal 0, ApiKey.count
    
  end

  test "shouldn't remove api key if associated annotation is removed" do
    Annotation.delete_all
    ApiKey.delete_all
    
    api_key = ApiKey.new(:email => "apikeyemail@invalid.com")
    assert api_key.save
    
    annotation = Annotation.new(:api_key => api_key);
    assert annotation.save
    
    assert_equal 1, Annotation.count
    assert_equal 1, ApiKey.count
    
    assert annotation.destroy
    
    assert_equal 0, Annotation.count
    assert_equal 1, ApiKey.count
  end
  
end
