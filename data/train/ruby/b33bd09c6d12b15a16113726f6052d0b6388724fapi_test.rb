require 'test_helper'

class ApiTest < Test::Unit::TestCase

  context "attributes" do

    setup do
      @api_key = "123-us1"
    end

    should "have no API by default" do
      @api = Mailchimp::API.new
      assert_equal(nil, @api.api_key)
    end

    should "set an API key in constructor" do
      @api = Mailchimp::API.new(@api_key)
      assert_equal(@api_key, @api.api_key)
    end

    should "set an API key from the 'MAILCHIMP_API_KEY' ENV variable" do
      ENV['MAILCHIMP_API_KEY'] = @api_key
      @api = Mailchimp::API.new
      assert_equal(@api_key, @api.api_key)
      ENV.delete('MAILCHIMP_API_KEY')
    end

    should "set an API key via setter" do
      @api = Mailchimp::API.new
      @api.api_key = @api_key
      assert_equal(@api_key, @api.api_key)
    end

    should "set timeout and get" do
      @api = Mailchimp::API.new
      timeout = 30
      @api.timeout = timeout
      assert_equal(timeout, @api.timeout)
    end
  end

  context "build api url" do
    setup do
      @api = Mailchimp::API.new
      @url = "https://api.mailchimp.com/1.3/?method=sayHello"
    end

    should "handle empty api key" do
      expect_post(@url, {:apikey => nil})
      @api.say_hello
    end

    should "handle malformed api key" do
      @api_key = "123"
      @api.api_key = @api_key
      expect_post(@url, {:apikey => @api_key})
      @api.say_hello
    end

    should "handle timeout" do
      expect_post(@url, {:apikey => nil}, 120)
      @api.timeout=120
      @api.say_hello
    end

    should "handle api key with dc" do
      @api_key = "TESTKEY-us1"
      @api.api_key = @api_key
      expect_post("https://us1.api.mailchimp.com/1.3/?method=sayHello", {:apikey => @api_key})
      @api.say_hello
    end
  end

  context "build api body" do
    setup do
      @key = "TESTKEY-us1"
      @api = Mailchimp::API.new(@key)
      @url = "https://us1.api.mailchimp.com/1.3/?method=sayHello"
      @body = {:apikey => @key}
    end

    should "escape string parameters" do
      @message = "simon says"
      expect_post(@url, @body.merge(:message => @message))
      @api.say_hello(:message => @message)
    end
=begin 
   #pending json enforced
    should "escape string parameters in an array" do
      pending 'json enforced'
      expect_post(@url, @body.merge("messages" => ["simon+says", "do+this"]))
      @api.say_hello(:messages => ["simon says", "do this"])
    end

    should "escape string parameters in a hash" do
      pending 'json enforced'
      expect_post(@url, @body.merge("messages" => {"simon+says" => "do+this"}))
      @api.say_hello(:messages => {"simon says" => "do this"})
    end

    should "escape nested string parameters" do
      pending 'json enforced'
      expect_post(@url, @body.merge("messages" => {"simon+says" => ["do+this", "and+this"]}))
      @api.say_hello(:messages => {"simon says" => ["do this", "and this"]})
    end
=end
    should "pass through non string parameters" do
      expect_post(@url, @body.merge(:fee => 99))
      @api.say_hello(:fee => 99)
    end
  end

  context "API instances" do
    setup do
      @key = "TESTKEY-us1"
      @api = Mailchimp::API.new(@key)
      @url = "https://us1.api.mailchimp.com/1.3/?method=sayHello"
      @body = {"apikey" => @key}
      @returns = Struct.new(:body).new(["array", "entries"].to_json)
    end

=begin
   #pending exception driven out in Base
    should "throw exception if configured to and the API replies with a JSON hash containing a key called 'error'" do
      @api.throws_exceptions = true
      Mailchimp::API.stubs(:post).returns(Struct.new(:body).new({'error' => 'bad things'}.to_json))
      assert_raise RuntimeError do
        @api.say_hello
      end
    end
=end
    should 'allow one to check api key validity' do
      Mailchimp::API.stubs(:post).returns(Struct.new(:body).new(%q{"Everything's Chimpy!"}))
      assert_equal true, @api.valid_api_key?
    end
  end


  private

  def expect_post(expected_url, expected_body, expected_timeout=nil)
    Mailchimp::API.expects(:post).with do |url, opts|
      url == expected_url &&
      opts[:body] == expected_body &&
      opts[:timeout] == expected_timeout
    end.returns(Struct.new(:body).new("") )
  end

end
