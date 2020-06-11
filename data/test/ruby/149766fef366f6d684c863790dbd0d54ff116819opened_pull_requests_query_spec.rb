require "rails_helper"

describe OpenedPullRequestsQuery do
  it "returns opened pull requests only" do
    repository = create(:repository)

    create(:pull_request, repository: repository, title: "Setup application", state: PullRequestState::ACCEPTED)
    create(:pull_request, repository: repository, title: "Configure Chef recipes", state: PullRequestState::PENDING)
    create(:pull_request, repository: repository, title: "Implement customers import", state: PullRequestState::REJECTED)

    results = OpenedPullRequestsQuery.new.results.map(&:title)
    expect(results).to include("Configure Chef recipes", "Implement customers import")
  end

  it "returns longer-waiting pull requests first" do
    repository = create(:repository)

    create(:pull_request, repository: repository, title: "Newest PR", opened_at: Time.new(2015, 1, 2, 10, 0, 0))
    create(:pull_request, repository: repository, title: "Oldest PR", opened_at: Time.new(2015, 1, 1, 10, 0, 0))
    create(:pull_request, repository: repository, title: "Usual PR", opened_at: Time.new(2015, 1, 1, 12, 0, 0))

    results = OpenedPullRequestsQuery.new.results.map(&:title)
    expect(results).to eq(["Oldest PR", "Usual PR", "Newest PR"])
  end
end
