require 'spec_helper'

describe OVOV::Calculator::Sprint do
  subject { OVOV::Calculator::Sprint.new }

  it 'calculates 0 points for poor performace' do
    subject.performance = 15.0
    expect(subject.calculate).to eq 0
  end

  it 'calculates 0 points for clearly impossible performace' do
    subject.performance = 1.99
    expect(subject.calculate).to eq 0
  end

  it 'calculates 830 points for 8.5s' do
    subject.performance = 8.5
    expect(subject.calculate).to eq 830
  end

  it 'calculates roughly 330 points for 11s' do
    subject.performance = 11
    expect(subject.calculate.round).to eq 330
  end

end
