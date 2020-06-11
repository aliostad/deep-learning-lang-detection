require 'spec_helper'

describe 'chunk' do
  it{ SpecHelper.empty_array.chunk { |element| true }.to_a.must_equal [] }
  it{ SpecHelper.for([1]).chunk    { |element| element.odd?  }.to_a.must_equal [[true,  [1]]] }
  it{ SpecHelper.for([1]).chunk    { |element| element.even? }.to_a.must_equal [[false, [1]]] }
  it{ SpecHelper.for([1, 2]).chunk { |element| element.odd?  }.to_a.must_equal [[true, [1]], [false, [2]]] }
  it{ SpecHelper.for([1, 2]).chunk { |element| element.even? }.to_a.must_equal [[false, [1]], [true, [2]]] }
  it{ SpecHelper.for([1, 2]).chunk { |element| element.zero? }.to_a.must_equal [[false, [1, 2]]] }
  it{ SpecHelper.for([1, 2]).chunk { |element| element > 0   }.to_a.must_equal [[true, [1, 2]]]  }
  it{ SpecHelper.for([1, 2, 3, 4, 5]).chunk { |element| element.odd? }.to_a.must_equal [[true, [1]], [false, [2]], [true, [3]], [false, [4]], [true, [5]]] }
end
