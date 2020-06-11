require 'rspec'
require_relative '../game'

describe Game do

  subject do
    Game.new
  end

  let(:score) { [5, 10, 20, 35, 30] }
  let(:array_frames) { [5, 10, 20, 35, 30] }
  let(:calculate_score) { 100 }

  it '#generate_frames' do
    subject.should_receive(:generate_frames).and_return score
    subject.generate_frames.should eq(score)
  end


  it '#calculate_score' do
    subject.should_receive(:generate_frames).and_return array_frames
    subject.calculate_score.should eq(calculate_score)
  end


  it '#print_total_score' do
    subject.should_receive(:calculate_score).and_return calculate_score
    subject.print_total_score.should eq(calculate_score)
  end

end
