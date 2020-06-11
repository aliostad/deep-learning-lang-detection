require 'rubygems'
require 'spec'
require 'score'

describe Score do

  it 'should return zero when player misses all' do
    score = Score.new([[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0,0]])
    score.calculate.should == 0
  end

  it 'should return 9 when player hits 4 and 5' do
    score = Score.new([[4, 5]])
    score.calculate.should == 9
  end

  it 'should return 15 when player hits [4,5] and [3,3]' do
    score = Score.new([[4, 5], [3,3]])
    score.calculate.should == 15
  end

  it 'should return 10 when player hits [3,/]' do
    score = Score.new([[3, "/"]])
    score.calculate.should == 10
  end

  it 'should return 10 when player hits [X,-]' do
    score = Score.new([["X", "-"]])
    score.calculate.should == 10
  end
end
