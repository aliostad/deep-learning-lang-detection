require './brute'

describe "Brute" do
	it "Should calculate the sum of a trivial triangle" do
		result = Brute.new([[5],[7,3]])
		result.start.should == 12
	end

	it "Should calculate the sum of a larger triangle" do
		result = Brute.new([[5],[7,3],[1,9,4]])
		result.start.should == 21
	end
	it "Should calculate the sum of the simple test triangle" do
		result = Brute.new([[3],[7,4],[2,4,6],[8,5,9,3]])
		result.start.should == 23
	end

	it "Should calculate the sum of the real triangle" do
		result = Brute.create("triangle2.txt")
		result.start.should == 1074
	end
end