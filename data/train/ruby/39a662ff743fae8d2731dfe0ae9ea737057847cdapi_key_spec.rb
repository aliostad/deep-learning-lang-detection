require 'spec_helper'

describe ApiKey do
  let(:user) {User.create(:email => 'email@email.com', username: 'user', name: 'User')}
  it "creates api keys" do
    api_key = ApiKey.create(scope: 'session', user: user)
    api_key.should_not be_new_record
    api_key.expired_at.should be_a Time
    api_key.oauth_code.should_not be_empty
  end

  it "trade a code for a token" do
    api_key = ApiKey.create(scope: 'session', user: user)
    ApiKey.trade_oauth_code_for_access_token(api_key.oauth_code).should == api_key
    api_key.reload
    api_key.oauth_code.should be_nil
    api_key.access_token.should_not be_empty
  end
end