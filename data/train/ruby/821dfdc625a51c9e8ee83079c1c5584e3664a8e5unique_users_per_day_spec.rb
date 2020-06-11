require 'spec_helper'

describe MyDataProcessors::UniqueUsersPerDay do
  let(:identifier) { 'facebook.com' }
  let(:filename) { 'some-file-name' }

  let(:processor) do
    described_class.new(identifier: identifier, filename: filename)
  end

  describe '#process_chunk' do
    let(:chunk) { build(:visits_chunk, id: chunk_id) }

    before { subject.process_chunk(chunk) }

    subject { processor }

    context 'same chunk id as identifier' do
      let(:chunk_id) { identifier }
      its(:result) { is_expected.to include(chunk.date => 3) }
    end

    context 'diferent chunk id as identifier' do
      let(:chunk_id) { 'other' }
      its(:result) { is_expected.to_not include(chunk.date => 3) }
    end
  end

  describe '#process!' do
    let(:chunk1) { build(:visits_chunk, id: identifier, date: '2015-01-01') }
    let(:chunk2) { build(:visits_chunk, id: identifier, date: '2015-02-02') }
    let(:chunk3) { build(:visits_chunk, date: '2015-03-03') }

    before do
      expect(processor).to receive(:process_file).with(filename) do
        processor.process_chunk(chunk1)
        processor.process_chunk(chunk2)
        processor.process_chunk(chunk3)
      end
    end

    subject { processor.process! }

    it { is_expected.to include(chunk1.date => 3, chunk2.date => 3) }
  end
end
