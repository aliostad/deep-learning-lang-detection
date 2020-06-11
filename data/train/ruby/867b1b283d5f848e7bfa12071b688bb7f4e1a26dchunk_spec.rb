require 'spec_helper'

describe Nebulous::Chunk do
  context 'around chunk of csv data' do
    subject { Nebulous::Chunk }

    context '#full?' do
      let(:chunk) { subject.new size: size }

      before do
        chunk << ['row']
        chunk << ['row']
      end

      context 'when not full' do
        let(:size) { 3 }
        it 'returns expected value' do
          expect(chunk.full?).to be_falsy
        end
      end

      context 'when full' do
        let(:size) { 2 }
        it 'returns expected value' do
          expect(chunk.full?).to be_truthy
        end
      end
    end
  end
end
