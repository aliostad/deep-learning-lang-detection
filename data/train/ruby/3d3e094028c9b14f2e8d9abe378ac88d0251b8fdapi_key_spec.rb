require 'spec_helper'

describe ApiKey do
  it "should not be valid with a duplicate access_token" do
    api_key = create(:api_key)

    api_key_2 = create(:api_key)
    api_key_2.access_token = api_key.access_token

    api_key_2.save

    expect(api_key_2).not_to be_valid
    expect(api_key_2).to have(1).error_on(:access_token)
  end

  it "should have an access token when created" do
    api_key = create(:api_key)

    expect(api_key.access_token).not_to be_blank
  end

  describe "States" do
    let(:api_key) { create(:api_key) }

    it "should be active by default" do
      expect(api_key.aasm_state).to eq 'active'
    end

    it "should transition from active to revoked" do
      expect { api_key.revoke! }.to change { api_key.aasm_state }.from('active').to('revoked')
    end

    it "should transition from revoked to active" do
      api_key.revoke!
      expect { api_key.activate! }.to change { api_key.aasm_state }.from('revoked').to('active')
    end
  end
end
