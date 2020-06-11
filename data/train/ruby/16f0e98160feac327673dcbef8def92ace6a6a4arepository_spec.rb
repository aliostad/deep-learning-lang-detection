require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'repository'

describe "Repository" do

  it "should calculate stats" do
    log = "
User1

5 3 File1
2 2 File2

User1

2 2 File3

User 1

1 1 File1

User2

7 0 File1
0 3 File2
"

    repository = Repository.new("SampleRepository","ArbitraryDirectory", {"User 1"=> "User1"})
    repository.stub(:extract_log).and_return(log)
    repository.calculate_stats
    repository.commiters['User1'].should be(18)
    repository.commiters['User2'].should be(10)
    repository.commiters['User 1'].should be(nil)
  end

  it "should generate a summary" do
    delimiter = "#{200.chr}@@@"
    log = "User 1
12345
Message number 1#{delimiter}
User2
12344
Message number 2#{delimiter}
"
    repository = Repository.new("SampleRepository","ArbitraryDirectory", {"User 1"=> "User1"})
    repository.stub(:extract_log_with_messages).and_return(log)
    repository.generate_summary
    repository.summary['12345'][:commiter].should eql("User1")
    repository.summary['12345'][:time].should eql(Time.at(12345))
    repository.summary['12345'][:message].should eql("Message number 1")
    repository.summary['12344'][:commiter].should eql("User2")
    repository.summary['12344'][:time].should eql(Time.at(12344))
    repository.summary['12344'][:message].should eql("Message number 2")
  end

end
