require 'sshkit/chunky/runner/chunks'

describe SSHKit::Chunky::Runner::Chunks do
  describe '#each_chunk' do
    let(:options) { { count: 4, sleep: 0 } }
    let(:block_to_run) { ->(host) { execute "echo #{Time.now.to_i}" } }
    let(:runner) do
      SSHKit::Chunky::Runner::Chunks.new(hosts, options, &block_to_run)
    end

    subject(:each_chunk) { runner.send(:each_chunk, hosts) }

    context 'with one host' do
      let(:hosts) { ['example.com'] }

      it 'returns 1 group' do
        expect(each_chunk.size).to eq 1
      end

      it 'returns 1 item in first group' do
        expect(each_chunk.first.size).to eq 1
      end
    end

    context 'with 3 hosts' do
      let(:hosts) { ['example.com'] * 3 }

      it 'returns 3 groups' do
        expect(each_chunk.size).to eq 3
      end

      it 'returns 1 item in each group' do
        expect(each_chunk[0].size).to eq 1
        expect(each_chunk[1].size).to eq 1
        expect(each_chunk[2].size).to eq 1
      end
    end

    context 'with 8 hosts' do
      let(:hosts) { ['example.com'] * 8 }

      it 'returns 4 groups' do
        expect(each_chunk.size).to eq 4
      end
      it 'returns 2 items in each group' do
        expect(each_chunk[0].size).to eq 2
        expect(each_chunk[1].size).to eq 2
        expect(each_chunk[2].size).to eq 2
        expect(each_chunk[3].size).to eq 2
      end
    end

    context 'with 9 hosts' do
      let(:hosts) { ['example.com'] * 9 }

      it 'returns 4 groups' do
        expect(each_chunk.size).to eq 4
      end

      it 'returns 3 items in first group' do
        expect(each_chunk[0].size).to eq 3
      end

      it 'returns 2 items in other groups' do
        expect(each_chunk[1].size).to eq 2
        expect(each_chunk[2].size).to eq 2
        expect(each_chunk[3].size).to eq 2
      end
    end
  end
end
