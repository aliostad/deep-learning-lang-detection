$LOAD_PATH << '.'
require 'athena_health_object_class'

describe "count_uniq_permutations(array)" do

	it "should output 1 when passed A" do
		input = "A".split("")
		expect(input.count_uniq_permutations).to eq(1)
	end

	it "should output 1 when passed AAAAAAAAAAAAAA" do
		input = "AAAAAAAAAAAAAA".split("")
		expect(input.count_uniq_permutations).to eq(1)
	end

	it "should output 14 when passed AAAAAAAAAAAAAB" do
		input = "AAAAAAAAAAAAAB".split("")
		expect(input.count_uniq_permutations).to eq(14)
	end

	it "should output 90 when passed AABBCC" do
		input = "AABBCC".split("")
		expect(input.count_uniq_permutations).to eq(90)
	end

	it "should output 1680 when passed AAABBBCCC" do
		input = "AAABBBCCC".split("")
		expect(input.count_uniq_permutations).to eq(1680)
	end

	# should output the same thing as previous when input letters are scrambled
	it "should output 1680 when passed BCABACABC" do
		input = "BCABACABC".split("")
		expect(input.count_uniq_permutations).to eq(1680)
	end

	it "should output 7821830016000 when passed AAAAAABBBCCCDEEEFGHH" do
		input = "AAAAAABBBCCCDEEEFGHH".split("")
		expect(input.count_uniq_permutations).to eq(7821830016000)
	end

end

describe "calculate_rank" do
	# it should work when there are no repeated letters
	it "should return 21 when passed DBAC" do
		input = Permutation.new("DBAC")
		expect(input.calculate_rank).to eq(21)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	# it should work when there are repeated letters
	it "should return 2 when passed ABAB" do
		input = Permutation.new("ABAB")
		expect(input.calculate_rank).to eq(2)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end
	
	it "should return 1 when passed AAAAAAAAAAAAAAAAAAAAAAAAAAAA" do
		input = Permutation.new("AAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		expect(input.calculate_rank).to eq(1)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	it "should return 1 when passed AAAB" do
		input = Permutation.new("AAAB")
		expect(input.calculate_rank).to eq(1)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	it "should return 4 when passed BAAA" do
		input = Permutation.new("BAAA")
		expect(input.calculate_rank).to eq(4)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	# test another long-ish word against the result from the iterative method
	it "should return 124678 when passed PORCUPINE" do
		input = Permutation.new("PORCUPINE")
		expect(input.calculate_rank).to eq(124678)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	# can it identify the first string out of the letters from PORCUPINE?
	it "should return 1 when passed CEINOPPRU" do
		input = Permutation.new("CEINOPPRU")
		expect(input.calculate_rank).to eq(1)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	# can it identify the first string out of the letters from PORCUPINE when case is mixed?
	it "should return 1 when passed CeinOPpRU" do
		input = Permutation.new("CeinOPpRU")
		expect(input.calculate_rank).to eq(1)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	it "should return 24572 when passed QUESTION" do
		input = Permutation.new("QUESTION")
		expect(input.calculate_rank).to eq(24572)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	it "should return 10743 when passed BOOKKEEPER" do
		input = Permutation.new("BOOKKEEPER")
		expect(input.calculate_rank).to eq(10743)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	it "should return 8222334634 when passed NONINTUITIVENESS" do
		input = Permutation.new("NONINTUITIVENESS")
		expect(input.calculate_rank).to eq(8222334634)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	# it should return the same as before when capitolization is changed
	it "should return 8222334634 when passed NoNINTUitIVEnesS" do
		input = Permutation.new("NoNINTUitIVEnesS")
		expect(input.calculate_rank).to eq(8222334634)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	# it should return the same as before when everything is lowercase
	it "should return 8222334634 when passed nonintutitivenesS" do
		input = Permutation.new("NoNINTUitIVEnesS".downcase)
		expect(input.calculate_rank).to eq(8222334634)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end

	it "can identify a crazy long string that's in alphabetical order" do
		input = Permutation.new("bbbbbbbbbbbbbbbbbbbbccccfggggghmooooopqsssstwxxxxxxxxxxxxxxxxxxxxxxxyzzzz")
		expect(input.calculate_rank).to eq(1)
		expect(Benchmark.realtime { input.calculate_rank }).to be < 0.5
	end	


end

