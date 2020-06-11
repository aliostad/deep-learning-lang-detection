require 'spec_helper'

describe Repository do
  it "not have two of the same repository" do
    create(:repository)
    repository2 = build(:repository)

    expect(repository2).to_not be_valid
  end

  let(:repository) { create(:repository) }

  it "#current_build", "return last build" do
    create(:build, repository: repository)
    build2 = create(:build, repository: repository)
    expect(repository.current_build).to eq(build2)
  end

  it "#klasses", "return classes from current_build" do
    klass = create(:klass)
    create(:build, repository: repository, klasses: [ klass ])

    expect(repository.klasses).to include(klass)
  end

  it "#clone_url", "return name for clone" do
    repository.name = "adbatista/scouter"
    expect(repository.clone_url).to eq("https://github.com/adbatista/scouter.git")
  end
end