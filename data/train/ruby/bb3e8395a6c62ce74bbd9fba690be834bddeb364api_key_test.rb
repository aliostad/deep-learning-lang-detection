require_relative '../test_helpers'

class ApiKeyTest < Test::Unit::TestCase
  include TestHelpers
  
  def setup
    @valid_api_key = 'valid'
    @invalid_api_key = 'invalid'

    $redis.flushdb
    $redis.sadd 'api_keys', @valid_api_key
  end

  def test_no_api_key
    post '/api'
    assert_equal 401, last_response.status, 'Should reject POST when no API key'
  end

  def test_no_api_key_response
    post '/api'
    assert_equal 'Missing API Key', last_response.body, 'Should give rejection message'
  end

  def test_invalid_api_key
    header('X-Api-Key', @invalid_api_key)
    post '/api'
    assert_equal 403, last_response.status, 'Should reject POST when invalid API key'
  end

  def test_invalid_api_key_response
    header('X-Api-Key', @invalid_api_key)
    post '/api'
    assert_equal 'Invalid API Key', last_response.body, 'Should give rejection message'
  end

  def test_valid_api_key
    header('X-Api-Key', @valid_api_key)
    post '/api'
    assert_equal 200, last_response.status, 'Should accept POST when valid API key'
  end
end
