require './testable.rb'
require 'rspec/its'

describe TestableClass1, "calculation" do
  subject { TestableClass1.new }

  it { expect(subject.calculate(10)).to eq 10 }
  it { expect(subject.calculate(100)).to eq 100 }
  it { expect(subject.calculate(10)).not_to eq 100 }
end

describe TestableClass2, "calculation" do
  subject { TestableClass2.new(3,5) }

  it { expect(subject.calculate(10)).to eq 23 }
  it { expect(subject.calculate(100)).to eq 2318 }
  it { expect(subject.calculate(1000)).to eq 233168 }
  it { expect(subject.calculate(10)).not_to eq 24 }
end

describe TestableClass3, "calculation" do
  subject { TestableClass3.new }

  it { expect(subject.calculate(10)).to eq 2640 }
  it { expect(subject.calculate(100)).to eq 25164150 }
  it { expect(subject.calculate(10)).not_to eq 2641 }
end

describe TestableClass4, "calculation" do
  subject { TestableClass4.new }

  it { expect(subject.calculate(10)).to eq 55 }
  it { expect(subject.calculate(20)).to eq 6765 }
  it { expect(subject.calculate(10)).not_to eq 56 }
end