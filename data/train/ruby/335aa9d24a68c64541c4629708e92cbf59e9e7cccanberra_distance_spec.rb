require 'spec_helper'

describe CanberraDistance do

  let(:klass) { subject.class }

  it 'raises an error on cardinality mismatch' do
    expect {
      klass.calculate([1], [1, 2])
    }.to raise_error(ArgumentError, /cardinality/i)
  end

  it 'returns 0 for identical vectors' do
    klass.calculate([1, 2, 3], [1, 2, 3]).should == 0
    klass.calculate([0, 0], [0, 0]).should == 0
  end

  it 'calculates the canberra distance' do
    klass.calculate([1], [2]).should == 1.0 / 3
    klass.calculate([2], [3]).should == 1.0 / 5
    klass.calculate([1, 2], [3, 4]).should == (2.0 / 4) + (2.0 / 6)
    klass.calculate([-1, -2], [3, 4]).should == (4.0 / 4) + (6.0 / 6)
    klass.calculate([0.5, -1, 2], [0.5, 0.5, 3]).
      should == 0 + (1.5 / 1.5) + (1.0 / 5)
  end

  it 'is more sensitive around the origin' do
    near = klass.calculate([1, 1], [2, 2])
    far  = klass.calculate([2, 2], [3, 3])
    (near > far).should be_true

    near = klass.calculate([-1, -1], [-2, -2])
    far  = klass.calculate([-2, -2], [-3, -3])
    (near > far).should be_true
  end

end
