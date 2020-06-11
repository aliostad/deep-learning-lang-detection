# encoding: UTF-8

require 'spec_helper'

describe HTML::Fragment, '#each' do
  let(:yields) { [] }

  let(:object) { described_class.new(chunk) }

  let(:chunk) { double('Chunk') }

  context 'with block' do
    subject { object.each { |chunk| yields << chunk } }

    it 'should enumerate chunks' do
      expect { subject }.to change { yields }.from([]).to([chunk])
    end

    it_should_behave_like 'a command method'
  end

  context 'without block' do
    subject { object.each }

    it { should be_a(Enumerator) }

    its(:to_a) { should eql([chunk]) }
  end
end
