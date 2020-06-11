require 'spec_helper'

describe TedApi::Client do
  it 'should instantiate with api key' do
    proc {
      TedApi::Client.new(api_key: 'foo')
    }.should_not raise_exception
  end

  describe "api_endpoint" do
    after(:each) do
      TedApi.reset
    end

    it "should default to https://api.ted.com/" do
      client = TedApi::Client.new
      client.api_endpoint.should == 'https://api.ted.com/'
    end

    it "should be set " do
      TedApi.api_endpoint = 'http://foo.dev'
      client = TedApi::Client.new
      client.api_endpoint.should == 'http://foo.dev/'
    end
  end
end