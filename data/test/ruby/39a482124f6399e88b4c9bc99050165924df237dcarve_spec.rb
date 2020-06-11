require 'spec_helper'

describe Carve do
  subject { Carve }

  describe "defaults" do
    before do
      subject.secret_api_key  = nil
      subject.api_version     = nil
    end

    it { subject.api_endpoint.should eq "https://carve.herokuapp.com/api/v0" }
    it { subject.api_version.should eq 0 }
  end

  describe "setting values" do
    let(:secret_api_key)  { "sk_1234" }
    let(:api_version)     { 1 }

    before do
      subject.secret_api_key  = secret_api_key
      subject.api_version     = api_version
    end

    it { subject.api_version.should eq api_version }
    it { subject.secret_api_key.should eq secret_api_key }
    it { subject.api_endpoint.should eq "https://carve.herokuapp.com/api/v1" }
  end

  describe "setting _root_url" do
    let(:api_version)     { 0 }

    before do
      subject.api_version   = api_version
      subject._root_url     = "http://localhost:3000"
    end

    it { subject._root_url = "http://localhost:3000" }
    it { subject.api_endpoint.should eq "http://localhost:3000/api/v0" }
  end
end