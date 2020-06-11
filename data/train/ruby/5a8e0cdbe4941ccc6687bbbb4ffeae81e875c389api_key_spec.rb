require 'rails_helper'

RSpec.describe ApiKey, :type => :model do
  let(:api_key) { "123456789" }
  let(:role) { "internal_api_client" }
  let(:api_keys) { { api_key => role } }

  describe "class methods" do
    it "should load api keys when calling .load_api_keys" do
      YAML.should_receive(:load_file).and_return(api_keys)
      ApiKey.load_api_keys
    end

    it "should return path to api keys yaml file" do
      expect(ApiKey.api_keys_file_path).to eq(Rails.root.join('config/api_keys.yml'))
    end

    it "should return api key for role" do
      ApiKey.should_receive(:load_api_keys).and_return(api_keys)
      expect(ApiKey.key_for_role(role)).to eq(api_key)
    end

    it "should raise error if key cannot be found for role" do
      ApiKey.should_receive(:load_api_keys).and_return(api_keys)
      bad_role = "bad_role"
      expect { ApiKey.key_for_role(bad_role) }.to raise_error("No API key found for #{bad_role}")
    end
  end

  describe "instance methods" do
    it "should load api keys upon initialize" do
      ApiKey.should_receive(:load_api_keys).and_return(api_keys)
      api = ApiKey.new(api_key)
      expect(api.api_keys).to eq(api_keys)
    end

    it "should take key as a param and set it upon initialize" do
      ApiKey.should_receive(:load_api_keys).and_return(api_keys)
      key = "some_key"
      api = ApiKey.new(key)
      expect(api.key).to eq(key)
    end

    it "should map roles of the api key" do
      ApiKey.should_receive(:load_api_keys).and_return(api_keys)
      api = ApiKey.new(api_key)
      expect(api.role).to eq(api_keys[api_key])
    end

    it "should check if api key is valid" do
      ApiKey.should_receive(:load_api_keys).and_return(api_keys)
      api = ApiKey.new(api_key)
      expect(api.valid?).to eq(true)
    end
  end
end
