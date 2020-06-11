require 'test_helper'

class STSTest < Test::Unit::TestCase
  
  DEFAULT_OPTIONS= {:options=>{:track_opens=>true, :track_clicks=>true}}

  context "attributes" do

    setup do
      @api_key = "123-us1"
    end

    should "have no API by default" do
      @api = Mailchimp::STS.new
      assert_equal(nil, @api.api_key)
    end

    should "set an API key in constructor" do
      @api = Mailchimp::STS.new(@api_key)
      assert_equal(@api_key, @api.api_key)
    end

    should "set an API key from the 'MAILCHIMP_API_KEY' ENV variable" do
      ENV['MAILCHIMP_API_KEY'] = @api_key
      @api = Mailchimp::STS.new
      assert_equal(@api_key, @api.api_key)
      ENV.delete('MAILCHIMP_API_KEY')
    end

    should "set an API key via setter" do
      @api = Mailchimp::STS.new
      @api.api_key = @api_key
      assert_equal(@api_key, @api.api_key)
    end

    should "set timeout and get" do
      @api = Mailchimp::STS.new
      timeout = 30
      @api.timeout = timeout
      assert_equal(timeout, @api.timeout)
    end
  end

  context "build api url" do
    setup do
      @api = Mailchimp::STS.new
      @url = "https://sts.mailchimp.com/1.0/Ping"
    end
  
    should "handle empty api key" do
      expect_post(@url, DEFAULT_OPTIONS.merge(:apikey => nil))
      @api.ping
    end
  
    should "handle api key" do
      @api_key = "123-us1"
      @api.api_key = @api_key
      expect_post("https://us1.sts.mailchimp.com/1.0/Ping", DEFAULT_OPTIONS.merge(:apikey => @api_key))
      @api.ping
    end
      
    should "handle timeout" do
      expect_post(@url, DEFAULT_OPTIONS.merge(:apikey => nil), 120)
      @api.timeout = 120
      @api.ping
    end
  end
  
  private
  
  def expect_post(expected_url, expected_body, expected_timeout=nil)
    Mailchimp::STS.expects(:post).with do |url, opts|
      url == expected_url &&
      opts[:body] == expected_body &&
      opts[:timeout] == expected_timeout
    end.returns(Struct.new(:body).new("") )
  end
end
