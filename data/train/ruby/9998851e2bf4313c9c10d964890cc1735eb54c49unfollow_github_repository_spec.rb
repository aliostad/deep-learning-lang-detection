require 'spec_helper'

describe UnfollowGithubRepositoryUsecase do

  fake(:db)                      { Db }
  fake(:github_adapter_instance) { Github::Adapter }
  let(:github_adapter)           { fake(:new => github_adapter_instance) }
  fake(:repository)              { Repository }
  let(:user)                     { User.create(:nickname => "bob") }

  subject { described_class.new(user, repository, github_adapter, db) }

  before { subject.execute }

  it "unfollow repository hook" do
    db.should have_received.unfollow_repository(repository)
  end

end
