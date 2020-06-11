require 'spec_helper'

describe Bucket::Client do
  subject { Bucket::Client.new({ "username" => "user", "password" => "password" }) }

  it "returns the correct repository url when using USER/REPOSITORY syntax" do
    subject.repo_url("other_user/repository").must_equal("git@bitbucket.org:other_user/repository.git")
  end

  it "returns the correct repository url when using REPOSITORY syntax" do
    subject.repo_url("repository").must_equal("git@bitbucket.org:user/repository.git")
  end

  it "returns the full name of a repository from a hash containing the repository information" do
    repo_hash = { owner: "user", slug: "repository" }

    subject.repo_full_name(repo_hash).must_equal("user/repository")
  end
end