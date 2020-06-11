require 'spec_helper'

describe RepositoryHandler do
  let(:git) { double("Git") }
  let(:file_utils) { double("FileUtils") }
  let(:repository_url) { 'www.example.abc.git' }
  subject { RepositoryHandler.new git, file_utils }

  describe "#create_repository" do
    it "clone a repository" do
      expect(git).to receive(:clone)

      subject.create_repository(repository_url)
    end
  end

  describe "#destroy_repository" do
    it "does something" do
      expect(file_utils).to receive(:remove_dir)

      subject.destroy_repository "repository/path"
    end
  end
end