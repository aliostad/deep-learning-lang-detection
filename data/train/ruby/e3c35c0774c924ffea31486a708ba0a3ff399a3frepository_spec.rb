require 'spec_helper'

describe Repository do
  it "should fail to save without url" do
    repository = build(:repository, {
      url: nil
    })

    repository.save

    expect( repository.errors[:url] ).not_to be_blank
  end

  it "should generate a title from the url" do
    repository = create(:repository)
    repository.url = "git@github.com:resque/resque-scheduler.git"
    repository.title.should == "resque-scheduler"
    repository.url = "git@github.com:resque/test/resque-scheduler.git"
    repository.title.should == "resque-scheduler"
  end

  it "should fail to save without directory" do 
    repository = build(:repository, {
      directory: nil
    })

    repository.save

    expect( repository.errors[:directory] ).not_to be_blank
  end
end
