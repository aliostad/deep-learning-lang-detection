require 'test_helper'

class MandrillTest < Test::Unit::TestCase
  
  DEFAULT_OPTIONS= {:options=>{:track_opens=>true, :track_clicks=>true}}

  context "attributes" do
    setup do
      @api_key = "123-us1"
    end

    should "have no API by default" do
      @api = Mailchimp::Mandrill.new
      assert_equal(nil, @api.api_key)
    end

    should "set an API key in constructor" do
      @api = Mailchimp::Mandrill.new(@api_key)
      assert_equal(@api_key, @api.api_key)
    end

    should "set an API key from the 'MAILCHIMP_API_KEY' ENV variable" do
      ENV['MAILCHIMP_API_KEY'] = @api_key
      @api = Mailchimp::Mandrill.new
      assert_equal(@api_key, @api.api_key)
      ENV.delete('MAILCHIMP_API_KEY')
    end

    should "set an API key via setter" do
      @api = Mailchimp::Mandrill.new
      @api.api_key = @api_key
      assert_equal(@api_key, @api.api_key)
    end

    should "set timeout and get" do
      @api = Mailchimp::Mandrill.new
      timeout = 30
      @api.timeout = timeout
      assert_equal(timeout, @api.timeout)
    end
  end

  context "build api url" do
    setup do
      @api = Mailchimp::Mandrill.new
      @url = "http://mandrillapp.com/api/1.0/users/ping"
    end
  
    should "handle empty api key" do
      expect_post(@url, DEFAULT_OPTIONS.merge(:key => nil))
      @api.users_ping
    end
      
    should "handle timeout" do
      expect_post(@url, DEFAULT_OPTIONS.merge(:key => nil), 120)
      @api.timeout = 120
      @api.users_ping
    end
  end
  
  private
  
  def expect_post(expected_url, expected_body, expected_timeout=nil)
    Mailchimp::Mandrill.expects(:post).with do |url, opts|
      url == expected_url &&
      opts[:body] == expected_body &&
      opts[:timeout] == expected_timeout
    end.returns(Struct.new(:body).new("") )
  end
end
