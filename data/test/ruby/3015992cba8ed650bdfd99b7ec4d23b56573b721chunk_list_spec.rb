require 'spec_helper'

describe GoogleSafeBrowsing::ChunkList do
  describe '#to_a' do
    let(:converted) { GoogleSafeBrowsing::ChunkList.new(raw_chunk_list).to_a }

    context 'with a single chunk number' do
      let(:raw_chunk_list) { '5' }
      let(:expected) { ['5'] }

      it 'converts to a single element array' do
        expect(converted).to eq expected
      end
    end

    context 'with a multiple chunk numbers' do
      let(:raw_chunk_list) { '5,8,10' }
      let(:expected) { raw_chunk_list.split(',') }

      it 'converts to a multiple element array' do
        expect(converted).to eq expected
      end
    end

    context 'with a chunk number range' do
      let(:raw_chunk_list) { '5-10' }
      let(:expected) { ['5', '6', '7', '8', '9', '10'] }

      it 'expands the range' do
        expect(converted).to eq expected
      end
    end

    context 'with chunk number ranges and numbers' do
      let(:raw_chunk_list) { '1-3,8,10-12,24' }
      let(:expected) { ['1', '2', '3', '8', '10', '11', '12', '24'] }

      it 'expands the ranges and includes the numbers' do
        expect(converted).to eq expected
      end
    end
  end
end
