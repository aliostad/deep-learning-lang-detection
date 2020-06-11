require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Howkast::API" do
  API_KEY1 = '6c6d1613339399efd0bc74fe12b14dd370b3ac76'
  API_KEY2 = 'bec946eaa53dc4e0527b28917f318fcd70b3ac76'
  
  before :all do
    @config ||= YAML.load File.read(File.expand_path(File.dirname(__FILE__) + '/../../.howkast'))
    Howkast::configure @config
    @howcast = Howkast::API.new
  end
  
  it "should honor configuration" do
    Howkast::configure :api_key => API_KEY1
    howcast = Howkast::API.new
    howcast.configuration.api_key.should eql API_KEY1
  end

  it "should be able to override configuration" do
    Howkast::configure :api_key => API_KEY1
    howcast = Howkast::API.new :api_key => API_KEY2
    howcast.configuration.api_key.should eql API_KEY2
  end
end
