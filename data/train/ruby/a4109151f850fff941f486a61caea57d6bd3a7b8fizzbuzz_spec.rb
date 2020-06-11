require 'rspec'
require 'fizzbuzz'

describe Fizzbuzz do
  context 'normal number' do
    it { subject.calculate(1).should eq 1 }
    it { subject.calculate(2).should eq 2 }
  end
  context 'Fizz number' do
    it { subject.calculate(3).should eq 'fizz' }
    it { subject.calculate(6).should eq 'fizz' }
    it { subject.calculate(9).should eq 'fizz' }
  end
  context 'buzz number' do
    it { subject.calculate(5).should eq 'buzz' }
    it { subject.calculate(10).should eq 'buzz' }
    it { subject.calculate(20).should eq 'buzz' }
  end
  context 'fizzbuzz  number' do
    it { subject.calculate(15).should eq 'fizzbuzz' }
    it { subject.calculate(30).should eq 'fizzbuzz' }
  end
  context 'GitHub number' do
    it { subject.calculate(17).should eq 'GitHub' }
    it { subject.calculate(27).should eq 'GitHub' }
    it { subject.calculate(75).should eq 'GitHub' }
    it { subject.calculate(77).should eq 'GitHub' }
  end
end
