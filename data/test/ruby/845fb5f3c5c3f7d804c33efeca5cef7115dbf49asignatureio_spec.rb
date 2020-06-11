require 'spec_helper'

describe Signatureio do
  subject { Signatureio }

  describe "defaults" do
    before do
      subject.secret_api_key  = nil 
      subject.public_api_key  = nil
      subject.api_version     = nil
    end

    it { subject.api_endpoint.should eq "https://www.signature.io/api/v0" }
    it { subject.api_version.should eq 0 }
  end

  describe "setting values" do
    let(:secret_api_key)  { "sk_1234" }
    let(:public_api_key)  { "pk_5678" }
    let(:api_version)     { 1 }

    before do
      subject.secret_api_key  = secret_api_key
      subject.public_api_key  = public_api_key
      subject.api_version     = api_version
    end

    it { subject.api_version.should eq api_version }
    it { subject.public_api_key.should eq public_api_key }
    it { subject.secret_api_key.should eq secret_api_key }
    it { subject.api_endpoint.should eq "https://www.signature.io/api/v1" }
  end

  describe "setting _root_url" do
    before do
      subject._root_url = "http://localhost:3000"
    end

    it { subject._root_url = "http://localhost:3000" }
    it { subject.api_endpoint.should eq "http://localhost:3000/api/v1" }
  end
end