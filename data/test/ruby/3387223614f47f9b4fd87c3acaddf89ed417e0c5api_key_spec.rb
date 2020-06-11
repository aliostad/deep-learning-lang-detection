require 'spec_helper'

describe ApiKey do
  it "should set expiration in the future" do
    api_key = create(:api_key)
    api_key.expires_at.should be > Time.zone.now
    api_key.should_not be_expired
  end

  it "should initialize token to random hex" do
    api_key = create(:api_key)
    api_key.token.size.should == 32
  end

  it "should be expired if expiration is past" do
    api_key = create(:expired_api_key)
    api_key.should be_expired
  end

  it "should be renewed if expiration is within renewal days" do
    api_key = create(:renewable_api_key)
    api_key.should_not be_expired
    api_key.should be_renewable
  end
end
