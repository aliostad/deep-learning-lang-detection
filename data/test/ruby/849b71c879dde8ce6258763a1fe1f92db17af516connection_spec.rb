require 'rubaiji'

describe Rubaiji::Connection do
  it "should return a connection class" do
    c = Rubaiji::Connection.new(:api_id => "test_api_id", :api_key => "test")
    c.class.should eql(Rubaiji::Connection)
  end

  it "should have api_key and api_id variables" do
    c = Rubaiji::Connection.new(:api_id => "test_api_id", :api_key => "test")
    c.api_id.should eql("test_api_id")
    c.api_key.should eql("test")
  end

  it "should return authentication error" do
    api_id = "root"
    api_key = "some invalid api_key"
    c = Rubaiji::Connection.new(:api_id => api_id, :api_key => api_key)

    expect {c.all_reports}.to raise_error(Rubaiji::AuthenticationError)
  end
end
