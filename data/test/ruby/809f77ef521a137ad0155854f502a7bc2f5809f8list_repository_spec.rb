require 'spec_helper'

describe ListRepository do
  before(:each) do
    @repository = ListRepository.new

    opened = List.create(:name => "Opened List")
    closed = List.create(:name => "Closed List")
    closed.close!

    @repository.add(opened)
    @repository.add(closed)
  end

  it "not available lists should not be retrieved from repository" do
    expect(@repository.all.count).to eq(1)
    expect(@repository.all.first.name).to eq("Opened List")
  end

  after(:each) do
    @repository = nil
  end
end
