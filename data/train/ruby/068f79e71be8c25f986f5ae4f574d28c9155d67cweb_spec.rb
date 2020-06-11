require "spec_helper"

describe Gemgate::Web do
  describe "POST /" do
    it "adds the gem to the repository" do
      uploaded_file = Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

      repository = double("repository")
      expect(repository).to receive(:add_gem).with(kind_of(String))

      described_class.repository = repository

      post "/", :file => uploaded_file
    end

    it "does not add the gem to the repository if authentication fails" do
      uploaded_file = Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

      repository = double("repository")
      expect(repository).not_to receive(:add_gem)

      described_class.repository = repository

      basic_authorize "in", "valid"

      post "/", :file => uploaded_file
    end

    it "does not add the gem to the repository if authentication info is not provided" do
      uploaded_file = Rack::Test::UploadedFile.new(fixture("foobar-0.0.1.gem"), "application/octet-stream")

      repository = double("repository")
      expect(repository).not_to receive(:add_gem)

      described_class.repository = repository

      header "Authorization", nil

      post "/", :file => uploaded_file
    end
  end
end
