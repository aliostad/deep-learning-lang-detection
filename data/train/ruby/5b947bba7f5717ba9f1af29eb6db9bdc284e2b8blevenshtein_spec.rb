require 'spec_helper'

describe ::SlideRule::DistanceCalculators::Levenshtein do
  let(:subject) { described_class.new }

  it 'should calculate perfect match' do
    expect(subject.calculate('this is a test', 'this is a test')).to eq(0.0)
  end

  it 'should calculate distance as distance divided by length of longest string' do
    expect(subject.calculate('this is a test', 'this is a test!').round(4)).to eq((1.0 / 15).round(4))
  end

  it 'should handle nils' do
    expect(subject.calculate(nil, nil)).to eq(0.0)
    expect(subject.calculate(nil, 'goodbye')).to eq(1.0)
    expect(subject.calculate('hello', nil)).to eq(1.0)
  end
end
